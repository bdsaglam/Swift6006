//
//  IntExtensions.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 10.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

extension Int {
    func digit(at index: Int, base: Int = 10) -> Int {
        var number = abs(self)
        for _ in 0..<index {
            number /= base
        }
        return number % base
    }
    
    func countDigits(base: Int = 10) -> Int {
        var count = 0
        var number = abs(self)
        while number > 0 {
            count += 1
            number /= base
        }
        return count
    }
    
    func digits(base: Int = 10) -> [Int] {
        var ds = [Int]()
        var number = abs(self)
        while number > 0 {
            ds.append(number % base)
            number /= base
        }
        
        return ds.reversed()
    }
    
    init<S: Sequence>(digits: S, isNegative: Bool, base: Int = 10) where S.Element == Int {
        let number = digits.reduce(0) { (acc, digit) -> Int in
            return acc * base + digit
        }
        
        self = isNegative ? -number : number
    }
}
