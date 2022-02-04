//
//  RedBlackTree.swift
//  RedBlackTree
//
//  Created by Герман Иванилов on 30/12/2021.
//

import Foundation

enum RotationDirection {
    case left
    case right
}

public class RedBlackTree<T: Comparable> {

    fileprivate(set) var root: Node<T>
    fileprivate var size = 0
    fileprivate let nullLeaf = Node<T>()

    public init() {
        root = nullLeaf
    }
}

extension RedBlackTree {
    public func count() -> Int {
        return size
    }

    public func isEmpty() -> Bool {
        return size == 0
    }

    public func allElements() -> [T] {
        var nodes: [T] = []

        getAllElements(node: root, nodes: &nodes)

        return nodes
    }

    private func getAllElements(node: Node<T>, nodes: inout [T]) {
        guard !node.isNullLeaf else {
            return
        }

        if let left = node.leftChild {
            getAllElements(node: left, nodes: &nodes)
        }

        if let value = node.value {
            nodes.append(value)
        }

        if let right = node.rightChild {
            getAllElements(node: right, nodes: &nodes)
        }
    }

    func allNodes() -> [Node<T>] {
        var nodes = [Node<T>]()

        getAllNodes(node: root, nodes: &nodes)

        return nodes
    }

    func getAllNodes(node: Node<T>, nodes: inout [Node<T>]){
        guard !node.isNullLeaf else { return }

        nodes.append(node)

        if let left = node.leftChild {
            getAllNodes(node: left, nodes: &nodes)
        }

        if let right = node.rightChild {
            getAllNodes(node: right, nodes: &nodes)
        }
    }
}

extension RedBlackTree {
    public func search(input: T) -> Node<T>? {
        return search(key: input, node: root)
    }

    fileprivate func search(key: T, node: Node<T>?) -> Node<T>? {
        guard let node = node else {
            return nil
        }

        if !node.isNullLeaf {
            if let nodeKey = node.value {

                if key == nodeKey {
                    return node
                } else if key < nodeKey {
                    return search(key: key, node: node.leftChild)
                } else {
                    return search(key: key, node: node.rightChild)
                }
            }
        }
        return nil
    }
}

extension RedBlackTree {

    public func insert(key: T) {
        if search(input: key) != nil {
            return
        }

        if root.isNullLeaf {
            root = Node<T>(key: key)
        } else {
            insert(input: Node<T>(key: key), node: root)
        }

        size += 1
    }

    private func insert(input: Node<T>, node: Node<T>) {
        guard let inputKey = input.value, let nodeKey = node.value else {
            return
        }
        if inputKey < nodeKey {
            guard let child = node.leftChild else {
                addAsLeftChild(child: input, parent: node)
                return
            }
            if child.isNullLeaf {
                addAsLeftChild(child: input, parent: node)
            } else {
                insert(input: input, node: child)
            }
        } else {
            guard let child = node.rightChild else {
                addAsRightChild(child: input, parent: node)
                return
            }
            if child.isNullLeaf {
                addAsRightChild(child: input, parent: node)
            } else {
                insert(input: input, node: child)
            }
        }
    }

    private func addAsLeftChild(child: Node<T>, parent: Node<T>) {
        parent.leftChild = child
        child.parent = parent
        child.color = .red
        insertFixup(node: child)
    }

    private func addAsRightChild(child: Node<T>, parent: Node<T>) {
        parent.rightChild = child
        child.parent = parent
        child.color = .red
        insertFixup(node: child)
    }

    private func insertFixup(node z: Node<T>) {
        if !z.isNullLeaf {
            guard let parentZ = z.parent else {
                return
            }
            if parentZ.color == .red {
                guard let uncle = z.uncle else {
                    return
                }
                if uncle.color == .red {
                    parentZ.color = .black
                    uncle.color = .black
                    if let grandparentZ = parentZ.parent {
                        grandparentZ.color = .red
                        insertFixup(node: grandparentZ)
                    }
                }
                else {
                    var zNew = z
                    if parentZ.isLeftChild && z.isRightChild {
                        zNew = parentZ
                        leftRotate(node: zNew)
                    } else if parentZ.isRightChild && z.isLeftChild {
                        zNew = parentZ
                        rightRotate(node: zNew)
                    }
                    zNew.parent?.color = .black
                    if let grandparentZnew = zNew.grandparent {
                        grandparentZnew.color = .red
                        if z.isLeftChild {
                            rightRotate(node: grandparentZnew)
                        } else {
                            leftRotate(node: grandparentZnew)
                        }
                    }
                }
            }
        }
        root.color = .black
    }
}

extension RedBlackTree {
    fileprivate func leftRotate(node x: Node<T>) {
        rotate(node: x, direction: .left)
    }

    fileprivate func rightRotate(node x: Node<T>) {
        rotate(node: x, direction: .right)
    }

    private func rotate(node x: Node<T>, direction: RotationDirection) {
        var nodeY: Node<T>? = Node<T>()

        switch direction {
        case .left:
            nodeY = x.rightChild
            x.rightChild = nodeY?.leftChild
            x.rightChild?.parent = x
        case .right:
            nodeY = x.leftChild
            x.leftChild = nodeY?.rightChild
            x.leftChild?.parent = x
        }

        nodeY?.parent = x.parent
        if x.isRoot {
            if let node = nodeY {
                root = node
            }
        } else if x.isLeftChild {
            x.parent?.leftChild = nodeY
        } else if x.isRightChild {
            x.parent?.rightChild = nodeY
        }

        switch direction {
        case .left:
            nodeY?.leftChild = x
        case .right:
            nodeY?.rightChild = x
        }
        x.parent = nodeY
    }
}
