//
//  AVLNode.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 14.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


final class AVLNode<Key: Comparable, Value> {
    let key: Key
    let value: Value
    
    var left: AVLNode<Key, Value>? {
        didSet { assert(checkSearchProperty()) }
    }
    var right: AVLNode<Key, Value>? {
        didSet { assert(checkSearchProperty()) }
    }
    var parent: AVLNode<Key, Value>?
    
    var height: Int = 0
    var skew: Int = 0
    
    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
    
    func updateHeightAndSkew() {
        let leftHeight = left?.height ?? -1
        let rightHeight = right?.height ?? -1
        height = Swift.max(leftHeight, rightHeight) + 1
        skew = rightHeight - leftHeight
    }
    
}

extension AVLNode : BinarySearchTreeNodeType {

    func insert(key: Key, value: Value) -> AVLNode {
        let node = _proInsert(key: key, value: value)
        node.updatePathToRoot()
        return node
    }
    
    func delete() throws {
        let parent = self.parent
        try _proDelete()
        parent?.updatePathToRoot()
    }
    
    private func updatePathToRoot() {
        var current: AVLNode<Key, Value>? = self
        
        while let node = current {
            node.updateHeightAndSkew()
            current = node.parent
        }
    }
    
    private func updateSubtree() {
        left?.updateSubtree()
        right?.updateSubtree()
        updateHeightAndSkew()
    }
}

class AVLTree<Key:Comparable, Value>: BaseBinarySearchTree<AVLNode<Key, Value>> {
    
    override func insert(key: Key, value: Value) {
        super.insert(key: key, value: value)
        
        maintain()
    }
    
    override func remove(key: Key) -> Value? {
        let result = super.remove(key: key)
               
        if result != nil {
            maintain()
        }
        return result
    }
        
    override func removeMin() -> (Key, Value)? {
        let result = super.removeMin()
                
        if result != nil {
            maintain()
        }
        return result
    }
    
    override func removeMax() -> (Key, Value)? {
        let result = super.removeMax()
                
        if result != nil {
            maintain()
        }
        return result
    }
    
    private func maintain() {
        guard let root = root else { return }
        if let inBalancedNode = findLowestViolating(root) {
            maintain(inBalancedNode)
        }
        assert(checkRepInvariance())
    }
    
    private func findLowestViolating(_ node: AVLNode<Key, Value>) -> AVLNode<Key, Value>? {
        if node.skew == 2 {
            let right = node.right!
            if right.skew == 2 {
                return findLowestViolating(right)
            }
            return node
        }
        
        if node.skew == -2 {
            let left = node.left!
            if left.skew == -2 {
                return findLowestViolating(left)
            }
            return node
        }
        
        return nil
    }
    
    private func maintain(_ node: AVLNode<Key, Value>) {
        balance(node)
        if let parent = node.parent {
            maintain(parent)
        }
    }
    
    private func balance(_ node: AVLNode<Key, Value>) {
        if node.skew == 2 {
            let right = node.right!
            if right.skew == -1 {
                rightRotate(right)
            }
            leftRotate(node)
        } else if node.skew == -2 {
            let left = node.left!
            if left.skew == 1 {
                leftRotate(left)
            }
            rightRotate(node)
        }
    }
    
    private func rightRotate(_ node: AVLNode<Key, Value>){
        guard let left = node.left else { return }
        
        let parent = node.parent
        let wasLeftChild = node === parent?.left
        node.unlinkParent()
        
        left.unlinkParent()
        
        if let leftRightChild = left.right {
            leftRightChild.unlinkParent()
            node.left = leftRightChild
            leftRightChild.parent = node
        }
        
        left.right = node
        node.parent = left
        
        left.parent = parent
        if wasLeftChild {
            parent?.left = left
        } else {
            parent?.right = left
        }
        
        node.updateHeightAndSkew()
        left.updateHeightAndSkew()
        parent?.updateHeightAndSkew()
        
        if node === root {
            root = left
        }
    }
    
    private func leftRotate(_ node: AVLNode<Key, Value>) {
        guard let right = node.right else { return  }
        
        let parent = node.parent
        let wasLeftChild = node === parent?.left
        node.unlinkParent()
        
        right.unlinkParent()
        
        if let rightLeftChild = right.left {
            rightLeftChild.unlinkParent()
            node.right = rightLeftChild
            rightLeftChild.parent = node
        }
        
        right.left = node
        node.parent = right
        
        right.parent = parent
        if wasLeftChild {
            parent?.left = right
        } else {
            parent?.right = right
        }
        
        node.updateHeightAndSkew()
        right.updateHeightAndSkew()
        parent?.updateHeightAndSkew()
        
        if node === root {
            root = right
        }
    }
    
}
