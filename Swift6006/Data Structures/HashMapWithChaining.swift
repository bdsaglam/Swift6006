//
//  HashMapType.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 2.02.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


public struct HashMapWithChaining<Key, Value>: HashMapType
where Key: Hashable & Equatable
{
    internal struct Item {
        var key: Key
        var value: Value
    }
    
    public private(set) var count: Int
    
    private let initialSize = 8
    private let growthFactor = 2
    private let shrinkFactor = 2
    private let shrinkThresholdFactor = 4
    
    private var table: [LinkedList<Item>?]
    private var tableSize: Int
    
    public init() {
        tableSize = initialSize
        table = Array.init(repeating: nil, count: initialSize)
        count = 0
    }
    
    public func get(_ key: Key) -> Value? {
        let bucketIndex = hash(key)
        guard let bucket = table[bucketIndex] else { return nil }
        
        for element in bucket {
            if element.key == key {
                return element.value
            }
        }
        
        return nil
    }
    
    public mutating func put(key: Key, value: Value) {
        if count == tableSize {
            growTable()
        }
        
        let element = Item(key: key, value: value)
        let bucketIndex = hash(key)
        guard let bucket = table[bucketIndex] else {
            let newBucket = LinkedList<Item>()
            newBucket.append(element)
            table[bucketIndex] = newBucket
            count += 1
            return
        }
        
        
        var j: Int? = nil
        loop: for (i, item) in bucket.enumerated() {
            if item.key == key {
                j = i
                break loop
            }
        }
        
        if let indexOfMatch = j {
            bucket.remove(at: indexOfMatch)
            count -= 1
        }
        
        bucket.append(element)
        count += 1
    }
    
    @discardableResult
    public mutating func remove(key: Key) -> Value? {
        let bucketIndex = hash(key)
        guard let bucket = table[bucketIndex] else { return nil }
        
        var j: Int? = nil
        loop: for (i, item) in bucket.enumerated() {
            if item.key == key {
                j = i
                break loop
            }
        }
        
        guard let indexOfMatch = j else { return nil }
        
        let element = bucket.remove(at: indexOfMatch)
        count -= 1
        
        if count < tableSize / shrinkThresholdFactor {
            shrinkTable()
        }
        
        return element.value
    }
        
    private mutating func growTable() {
        resizeTable(newSize: tableSize * growthFactor)
    }
    
    private mutating func shrinkTable() {
        resizeTable(newSize: tableSize / shrinkFactor)
    }
    
    private mutating func resizeTable(newSize: Int) {
        tableSize = newSize
        
        var newTable: [LinkedList<Item>?] = Array(repeating: nil, count: tableSize)
        
        for bucket in table.compactMap({ $0 }) {
            for element in bucket {
                let newBucketIndex = hash(element.key)
                if let newBucket = newTable[newBucketIndex] {
                    newBucket.append(element)
                }
                else {
                    let newBucket = LinkedList<Item>()
                    newBucket.append(element)
                    newTable[newBucketIndex] = newBucket
                }
            }
            
        }
        
        table = newTable
    }
    
    private func hash(_ key: Key) -> Int {
        let hashValue = key.hashValue
        var index = hashValue % tableSize
        if index < 0 {
            index = (index + tableSize) % tableSize
        }
        return index
    }
    
}

extension HashMapWithChaining: Sequence {
    public func makeIterator() -> AnyIterator<(Key, Value)> {
        let elements = table
            .compactMap { $0 }
            .flatMap { $0 }
            .map { ($0.key, $0.value) }
        
        var iterator = elements.makeIterator()
        return AnyIterator<(Key, Value)> {
            return iterator.next()
        }
    }
}

extension HashMapWithChaining: CustomStringConvertible
    where Key: CustomStringConvertible, Value: CustomStringConvertible {}
