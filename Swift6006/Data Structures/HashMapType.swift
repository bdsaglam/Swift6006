//
//  HashMapType.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 2.02.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


public protocol HashMapType: Sequence where Element == (Key, Value) {
    associatedtype Key: Hashable & Equatable
    associatedtype Value
    
    var count: Int { get }
    
    func get(_ key: Key) -> Value?
    
    mutating func put(key: Key, value: Value)
    
    mutating func remove(key: Key) -> Value?
}

extension HashMapType {
    public var keys: AnySequence<Key> {
        return AnySequence { () -> AnyIterator<Key> in
            var iterator = self.makeIterator()
            return AnyIterator { iterator.next()?.0 }
        }
    }
    
    public var values: AnySequence<Value> {
        return AnySequence { () -> AnyIterator<Value> in
            var iterator = self.makeIterator()
            return AnyIterator { iterator.next()?.1 }
        }
    }
}

extension HashMapType where Self: CustomStringConvertible,
Key: CustomStringConvertible, Value: CustomStringConvertible
{
    public var description: String {
        var s = "["
        for (key, value) in self {
            s.append("\(String(reflecting: key)): \((String(reflecting: value))), ")
        }
        s.removeLast()
        s.removeLast()
        s.append("]")
        return s
    }
}

