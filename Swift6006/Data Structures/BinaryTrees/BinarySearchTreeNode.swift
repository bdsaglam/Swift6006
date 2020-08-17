//
//  BinarySearchTreeNode.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 14.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


// MARK: Binary Search Tree Node Implementation (unbalanced)

final class BinarySearchTreeNode<Key: Comparable, Value>
: BinarySearchTreeNodeType
{
    let key: Key
    let value: Value
    
    var left: BinarySearchTreeNode<Key, Value>? {
        didSet { assert(checkSearchProperty()) }
    }
    var right: BinarySearchTreeNode<Key, Value>? {
        didSet { assert(checkSearchProperty()) }
    }
    var parent: BinarySearchTreeNode<Key, Value>?
    
    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}
