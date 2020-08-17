//
//  BinarySearchTreeNodeType.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 14.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


// MARK: Binary Search Tree Node Protocol

protocol BinarySearchTreeNodeType: BinaryTreeNodeType {
    func insert(key: Key, value: Value) -> Self
    
    func delete()
    
    func updateAfterMutation()
    
    func min() -> Self
    
    func max() -> Self
    
    func find(key: Key) -> Self?
    
    func findPredecessor() -> Self?
    
    func findSuccessor() -> Self?
    
    func findInRange(low: Key, high: Key) -> AnySequence<Self>
    
    func traverseInOrder() -> AnySequence<Self>
    
    func traverseByLevels() -> AnySequence<[Self]>
        
}

extension BinarySearchTreeNodeType {
    func checkSearchProperty() -> Bool {
        if let left = left, left.key > key { return false }
        if let right = right, right.key < key { return false }
        
        return true
    }
    
    func checkRepInvariance() -> Bool {
        guard checkSearchProperty() else { return false }

        return (left?.checkRepInvariance() ?? true) &&
            (right?.checkRepInvariance() ?? true)
    }
}

extension BinarySearchTreeNodeType {
    func unlinkParent() {
        guard let parent = parent else { return }
        
        self.parent = nil
        if self === parent.right {
            parent.right = nil
            return
        }
        if self === parent.left {
            parent.left = nil
            return
        }
    }
}

extension BinarySearchTreeNodeType {
    func insert(key: Key, value: Value) -> Self {
        let node = insertHelper(key: key, value: value)
        node.updateAfterMutation()
        return node
    }
        
    private func insertHelper(key: Key, value: Value) -> Self {
        if key <= self.key {
            if let left = left {
                return left.insert(key: key, value: value)
            } else {
                let node = Self(key: key, value: value)
                node.parent = self
                left = node
                return node
            }
        } else {
            if let right = right {
                return right.insert(key: key, value: value)
            } else {
                let node = Self(key: key, value: value)
                node.parent = self
                right = node
                return node
            }
        }
    }
    
    func delete() {
        guard let parent = parent else {
            fatalError("Cannot delete a node if it has no parent.")
        }
        
        if isLeaf {
            deleteEasy(promote: nil)
            return
        }
        
        if left == nil {
            deleteEasy(promote: right)
            return
        }
        
        if right == nil {
            deleteEasy(promote: left)
            return
        }
        
        let successor = self.right!.min()
        assert(successor.parent != nil)
        assert(successor.left == nil)
        
        let node = Self(key: successor.key, value: successor.value)
        node.left = self.left!
        node.left?.parent = node
        node.right = self.right!
        node.right?.parent = node
        self.left = nil
        self.right = node
        
        successor.deleteEasy(promote: successor.right)
        deleteEasy(promote: node)
        
        parent.updateAfterMutation()
    }
    
    private func deleteEasy(promote child: Self?) {
        guard let parent = parent else {
            fatalError("Cannot delete a node if it has no parent.")
        }
        
        child?.parent = parent
        if parent.left === self {
            parent.left = child
        } else {
            parent.right = child
        }
        
        self.parent = nil
        self.right = nil
        self.left = nil
    }
    
    func updateAfterMutation() {}
}

extension BinarySearchTreeNodeType {
    
    func min() -> Self {
        guard let left = left else { return self }
        
        return left.min()
    }
    
    func max() -> Self {
        guard let right = right else { return self }
        
        return right.max()
    }
    
    func find(key: Key) -> Self? {
        if key == self.key {
            return self
        }
        
        if key < self.key {
            guard let left = left else { return nil }
            return left.find(key: key)
        }
        
        guard let right = right else { return nil }
        return right.find(key: key)
    }
    
    func findPredecessor() -> Self? {
        if let left = left { return left.max() }
        
        var current = self
        while let parent = current.parent {
            if current === parent.right {
                return parent
            }
            current = parent
        }
        
        return nil
    }
    
    func findSuccessor() -> Self? {
        if let right = right { return right.min() }
        
        var current = self
        while let parent = current.parent {
            if current === parent.left {
                return parent
            }
            current = parent
        }
        
        return nil
    }
    
    func findInRange(low: Key, high: Key) -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var currentNode: Self? = self.min()
            
            while let node = currentNode, node.key < low {
                currentNode = node.findSuccessor()
            }
                        
            return AnyIterator {
                guard let node = currentNode else { return nil }
                guard node.key < high else { return nil }
                    
                currentNode = node.findSuccessor()
                
                return node
            }
        }
    }
    
    func traverseInOrder() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var currentNode: Self? = self.min()

            return AnyIterator {
                let result = currentNode
                currentNode = currentNode?.findSuccessor()
                return result
            }
        }
    }
    
    func traverseByLevels() -> AnySequence<[Self]> {
        return AnySequence { () -> AnyIterator<[Self]> in
            var queue: [Self] = [self]
            
            return AnyIterator {
                guard queue.count > 0 else { return nil }
                
                let result = queue
                queue = queue
                    .flatMap {(node: Self) -> [Self?] in [node.left, node.right] }
                    .compactMap { $0 }
                
                return result
            }
        }
    }
    
}



