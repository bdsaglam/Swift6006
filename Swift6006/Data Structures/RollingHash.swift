//
//  RollingHash.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 23.02.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


public class RollingHash {
    public private(set) var hash: Int
    
    private let divisor: Int
    private let radix: Int
    private let inverseOfRadix: Int
    
    private var baseForFirstDigit: Int
    private var queue: LinkedList<Int>
    
    public init(radix: Int, divisor: Int) {
        self.radix = radix
        self.inverseOfRadix = modularInverse(of: radix, divisor: divisor)
        self.divisor = divisor
        
        self.baseForFirstDigit = 1
        self.hash = 0
        
        self.queue = LinkedList<Int>()
    }
    
    public func append(_ digit: Int) {
        queue.append(digit)
        hash = (hash * radix + digit) % divisor
        
        if queue.count == 1 {
            baseForFirstDigit = 1
        } else {
            baseForFirstDigit = (baseForFirstDigit * radix) % divisor
        }
        
    }
    
    public func skipFirst() {
        if queue.isEmpty { return }
        
        let digit = queue.removeFirst()!
        hash = (hash - digit * baseForFirstDigit + divisor * radix) % divisor
        
        if queue.count == 1 {
            baseForFirstDigit = 1
        } else {
            baseForFirstDigit = (baseForFirstDigit * inverseOfRadix) % divisor
        }
    }
        
}


