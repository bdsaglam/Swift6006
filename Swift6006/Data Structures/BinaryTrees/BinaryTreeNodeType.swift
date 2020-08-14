//
//  BinaryTreeNodeType.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 10.01.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


protocol BinaryTreeNodeType: AnyObject {
    associatedtype Key: Comparable
    associatedtype Value
    
    var key: Key { get }
    var value: Value { get }
    
    var left: Self? { get set }
    var right: Self? { get set }
    var parent: Self? { get set }
    
    init(key: Key, value: Value)
    
}

extension BinaryTreeNodeType {
    var isLeaf: Bool {
        left == nil && right == nil
    }
    
    func toTuple() -> (Key, Value) {
        return (self.key, self.value)
    }
}


