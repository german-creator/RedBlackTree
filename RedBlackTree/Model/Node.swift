//
//  Node.swift
//  RedBlackTree
//
//  Created by Герман Иванилов on 30/12/2021.
//

import Foundation

enum NodeColor {
    case red
    case black
}

public class Node<T: Comparable> {

    var color: NodeColor = .black
    var value: T?
    var leftChild: Node?
    var rightChild: Node?
    
    weak var parent: Node?

    public init(key: T?, leftChild: Node?, rightChild: Node?, parent: Node?) {
        self.value = key
        self.leftChild = leftChild
        self.rightChild = rightChild
        self.parent = parent

        self.leftChild?.parent = self
        self.rightChild?.parent = self
    }

    public convenience init(key: T?) {
        self.init(key: key, leftChild: Node(), rightChild: Node(), parent: Node())
    }

    public convenience init() {
        self.init(key: nil, leftChild: nil, rightChild: nil, parent: nil)
        self.color = .black
    }

    var isRoot: Bool {
        return parent == nil
    }

    var isLeaf: Bool {
        return rightChild == nil && leftChild == nil
    }

    var isNullLeaf: Bool {
        return value == nil && isLeaf && color == .black
    }

    var isLeftChild: Bool {
        return parent?.leftChild === self
    }

    var isRightChild: Bool {
        return parent?.rightChild === self
    }

    var grandparent: Node? {
        return parent?.parent
    }

    var sibling: Node? {
        if isLeftChild {
            return parent?.rightChild
        } else {
            return parent?.leftChild
        }
    }

    var uncle: Node? {
        return parent?.sibling
    }
}

extension Node: Equatable {
    static public func == <T>(lhs: Node<T>, rhs: Node<T>) -> Bool {
        return lhs.value == rhs.value
    }
}


extension Node {
    public func minimum() -> Node<T>? {
        if let leftChild = leftChild {
            if !leftChild.isNullLeaf {
                return leftChild.minimum()
            }
            return self
        }
        return self
    }

    public func maximum() -> Node<T>? {
        if let rightChild = rightChild {
            if !rightChild.isNullLeaf {
                return rightChild.maximum()
            }
            return self
        }
        return self
    }

    public func height() -> Int {
        if isNullLeaf {
          return 0
        } else {
          return 1 + max(leftChild?.height() ?? 0, rightChild?.height() ?? 0)
        }
      }
}
