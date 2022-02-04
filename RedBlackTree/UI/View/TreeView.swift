//
//  TreeView.swift
//  RedBlackTree
//
//  Created by Герман Иванилов on 17/01/2022.
//

import UIKit

//Not perfect solution, buth fine as RBT example App
class TreeView: UIView {

    var nodeViews = [NodeView]()
    let edgesLayer = CAShapeLayer()

    let tree = RedBlackTree<Int>()

    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSetup()
    }

    private func initSetup() {
        layer.addSublayer(edgesLayer)
        setDefaultValues()
        updateContent()
    }

    func updateContent() {
        updateNodeItems()
        updateNodesConstraints()
        setSelfSize()
        drawEdges()
    }

    func updateContentWithAnimation() {
        self.setSelfSize()
        edgesLayer.path = nil

        UIView.animate(withDuration: 2) {
            self.updateNodesConstraints()
            self.layoutIfNeeded()
        } completion: {_ in
            self.drawEdges()
            self.updateNodesColor()
        }
    }

    func addNodeView(with value: Int, from point: CGPoint) {
        tree.insert(key: value)

        tree.allNodes().forEach { node in
            if !nodeViews.contains(where: { $0.node == node}) {
                let nodeView = addNodeView(node: node)

                nodeView.frame = CGRect(origin: point, size: CGSize(width: Constants.nodeSize, height: Constants.nodeSize))
            }
        }

        updateContentWithAnimation()
    }

    private func setDefaultValues() {
        tree.insert(key: 23)
        tree.insert(key: 10)
        tree.insert(key: 50)
        tree.insert(key: 100)
        tree.insert(key: 1)
        tree.insert(key: 37)
    }

    private func updateNodeItems() {
        tree.allNodes().forEach { node in
            if !nodeViews.contains(where: { $0.node == node}) {
                addNodeView(node: node)
            }
        }
    }

    private func updateNodesColor() {
        nodeViews.forEach { nodeView in
            nodeView.updateColor()
        }
    }

    @discardableResult
    private func addNodeView(node: Node<Int>) -> NodeView {
        let nodeView = NodeView()
        nodeView.node = node

        nodeView.translatesAutoresizingMaskIntoConstraints = false
        nodeViews.append(nodeView)
        self.addSubview(nodeView)

        return nodeView
    }

    private func updateNodesConstraints() {
        tree.allNodes().forEach { node in

            guard let nodeView = nodeViews.first(where: { $0.node == node }) else { return }

            if let parentView = nodeViews.first(where: { $0.node == node.parent }) {
                setNodeViewToParentConstraint(nodeView: nodeView, parentView: parentView)
            } else {
                setRootNodeViewConstraint(rootView: nodeView)
            }
        }
    }

    private func setRootNodeViewConstraint(rootView: NodeView) {
        rootView.removeConstraints()

        NSLayoutConstraint.activate([
            rootView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            rootView.widthAnchor.constraint(equalToConstant: Constants.nodeSize),
            rootView.heightAnchor.constraint(equalToConstant: Constants.nodeSize),
            rootView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.largeMargin)
        ])
    }

    private func setNodeViewToParentConstraint(nodeView: NodeView, parentView: NodeView) {
        guard let node = nodeView.node else { return }

        let height = node.height()

        nodeView.removeConstraints()

        NSLayoutConstraint.activate([
            nodeView.widthAnchor.constraint(equalToConstant: Constants.nodeSize),
            nodeView.heightAnchor.constraint(equalToConstant: Constants.nodeSize),
            nodeView.topAnchor.constraint(equalTo: parentView.bottomAnchor, constant: Constants.smallMargin),
            {
                node.isLeftChild ?
                nodeView.rightAnchor.constraint(equalTo: parentView.leftAnchor, constant: -(Constants.nodeSize * CGFloat(height - 1))) :
                nodeView.leftAnchor.constraint(equalTo: parentView.rightAnchor, constant: Constants.nodeSize * CGFloat(height - 1))
            }()
        ])
    }

    private func setSelfSize() {
        let height = tree.root.height()

        heightConstraint?.isActive = false
        widthConstraint?.isActive = false
        heightConstraint = heightAnchor.constraint(equalToConstant: CGFloat(height) * Constants.nodeSize * 2)
        widthConstraint = widthAnchor.constraint(equalToConstant: CGFloat(height) * Constants.nodeSize * 4)

        NSLayoutConstraint.activate([heightConstraint!, widthConstraint!])
    }

    private func drawEdges() {
        edgesLayer.frame = self.frame

        let path = UIBezierPath()

        nodeViews.forEach { nodeView in

            if let rightChild = nodeView.node?.rightChild,
               let childView = nodeViews.first(where: {$0.node == rightChild }) {

                path.move(to: CGPoint(x: nodeView.frame.midX, y: nodeView.frame.midY))
                path.addLine(to: CGPoint(x: childView.frame.midX, y: childView.frame.midY))
            }

            if let leftChild = nodeView.node?.leftChild,
               let childView = nodeViews.first(where: {$0.node == leftChild }) {

                path.move(to: CGPoint(x: nodeView.frame.midX, y: nodeView.frame.midY))
                path.addLine(to: CGPoint(x: childView.frame.midX, y: childView.frame.midY))
            }
        }

        edgesLayer.path = path.cgPath
        edgesLayer.lineWidth = 2
        edgesLayer.strokeColor = UIColor.gray.cgColor
    }
}

extension UIView {
    func removeConstraints() {
        let constraints = self.superview?.constraints.filter{
            $0.firstItem as? UIView == self || $0.secondItem as? UIView == self
        } ?? []

        self.superview?.removeConstraints(constraints)
        self.removeConstraints(self.constraints)
    }
}

