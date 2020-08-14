//
//  BinarySearchTreeType.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 14.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


protocol BinarySearchTreeType: AnyObject {
    associatedtype Key: Comparable
    associatedtype Value
    
    func min() -> (Key, Value)?
    
    func max() -> (Key, Value)?
    
    func find(key: Key) -> Value?
    
    func findPredecessor(key: Key) -> (Key, Value)?
    
    func findSuccessor(key: Key) -> (Key, Value)?
    
    func findInRange(low: Key, high: Key) -> AnySequence<(Key, Value)>
    
    func insert(key: Key, value: Value)
    
    func remove(key: Key) -> Value?
    
    func removeMin() -> (Key, Value)?
    
    func removeMax() -> (Key, Value)?
        
    func traverseInOrder() -> AnySequence<(Key, Value)>
    
    func traverseByLevels() -> AnySequence<[(Key, Value)]>
    
}
