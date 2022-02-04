//
//  NodeView.swift
//  RedBlackTree
//
//  Created by Герман Иванилов on 30/12/2021.
//

import UIKit

class NodeView: UIView {

    private let label = UILabel()

    var node: Node<Int>? {
        didSet {
            guard let node = node,
                  let value = node.value else { return }
            label.text = String(value)
            updateColor()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = rect.width / 2
        clipsToBounds = true

        label.textAlignment = .center
        label.textColor = .white

        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func updateColor() {
        backgroundColor = node?.color == .black ? .black : .red
    }
}
