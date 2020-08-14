//
//  BaseBinarySearchTree.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 14.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


class BaseBinarySearchTree<NodeType: BinarySearchTreeNodeType>
: BinarySearchTreeType
{
    typealias Key = NodeType.Key
    typealias Value = NodeType.Value
    
    var root: NodeType?
    private(set) var count: Int = 0
    
    func min() -> (Key, Value)? {
        return root?.min().toTuple()
    }
    
    func max() -> (Key, Value)? {
        return root?.max().toTuple()
    }
    
    func find(key: Key) -> Value? {
        return root?.find(key: key)?.value
    }
    
    func findPredecessor(key: Key) -> (Key, Value)? {
        return root?.find(key: key)?.findPredecessor()?.toTuple()
    }
    
    func findSuccessor(key: Key) -> (Key, Value)? {
        return root?.find(key: key)?.findSuccessor()?.toTuple()
    }
    
    func findInRange(low: Key, high: Key) -> AnySequence<(Key, Value)> {
        return AnySequence { () -> AnyIterator<(Key, Value)> in
            let iterator = self.root?.findInRange(low: low, high: high).makeIterator()
            return AnyIterator { iterator?.next()?.toTuple() }
        }
    }
    
    func insert(key: Key, value: Value) {
        if let root = root {
            _ = root.insert(key: key, value: value)
        } else {
            root = NodeType(key: key, value: value)
        }
        count += 1
        assert(checkRepInvariance())
    }
    
    func remove(key: Key) -> Value? {
        guard let root = root else { return nil }
        
        guard let node = root.find(key: key) else { return nil }
        
        let result = node.value
        remove(node)
        return result
    }
        
    func removeMin() -> (Key, Value)? {
        guard let root = root else { return nil }
        
        let node = root.min()
        let result = node.toTuple()
        remove(node)
        return result
    }
    
    func removeMax() -> (Key, Value)? {
        guard let root = root else { return nil }
        
        let node = root.max()
        let result = node.toTuple()
        remove(node)
        return result
    }
    
    private func remove(_ node: NodeType) {
        if root === node {
            removeRoot()
        } else {
            try! node.delete()
        }
        count -= 1
        assert(self.checkRepInvariance())
    }
    
    private func removeRoot() {
        let root = self.root!
        
        if root.isLeaf {
            self.root = nil
            return
        }
        
        if root.right == nil {
            let predecessor = root.findPredecessor()!
            precondition(predecessor.right == nil)
            precondition(predecessor.parent != nil)
            
            if predecessor.parent === root {
                predecessor.parent = nil
                self.root = predecessor
            } else {
                predecessor.parent!.right = predecessor.left
                predecessor.left?.parent = predecessor.parent!
                predecessor.left = nil
                
                predecessor.left = root.left
                predecessor.left?.parent = predecessor
                
                predecessor.parent = nil
                self.root = predecessor
            }
        } else {
            let successor = root.findSuccessor()!
            precondition(successor.left == nil)
            precondition(successor.parent != nil)
            
            if successor.parent === root {
                successor.left = root.left
                successor.left?.parent = successor
                
                successor.parent = nil
                self.root = successor
            } else {
                successor.parent!.left = successor.right
                successor.right?.parent = successor.parent!
                successor.right = nil
                
                successor.left = root.left
                successor.left?.parent = successor
                
                successor.right = root.right
                successor.right?.parent = successor
                
                successor.parent = nil
                self.root = successor
            }
        }
        
        root.left = nil
        root.right = nil
    }
    
    func traverseInOrder() -> AnySequence<(Key, Value)> {
        return AnySequence { () -> AnyIterator<(Key, Value)> in
            let iterator = self.root?.traverseInOrder().makeIterator()
            return AnyIterator { iterator?.next()?.toTuple() }
        }
    }
    
    func traverseByLevels() -> AnySequence<[(Key, Value)]> {
        return AnySequence { () -> AnyIterator<[(Key, Value)]> in
            let iterator = self.root?.traverseByLevels().makeIterator()
            return AnyIterator { iterator?.next()?.map { $0.toTuple() } }
        }
    }
    
    func checkRepInvariance() -> Bool {
        return root?.checkRepInvariance() ?? true
    }
    
}
