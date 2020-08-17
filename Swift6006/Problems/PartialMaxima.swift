//
//  PartialMaxima.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

/**
 Storing Partial Maxima
 The solution takes O(n*lg(n)) space to store some of the partial max in the array. Then, it takes constant time
 to query any partial max.
 */

class PartialMaxima<Element: Comparable> {
    struct Interval: Hashable {
        var start: Int
        var end: Int
    }
    private let array: [Element]
    private(set) var cache = [Interval: Element]()
    
    init(_ array: [Element]) {
        self.array = array
        fillCache()
    }
    
    func partialMax(start: Int, end: Int) -> Element {
        return partialMax(start: start, end: end, i: 0, j: array.count)
    }
    
    private func partialMax(start: Int, end: Int, i: Int, j: Int) -> Element {
        precondition(start < end)
        precondition(start >= 0)
        precondition(end <= array.count)
        
        if let result = lookUpMax(start: start, end: end) {
            return result
        }
        
        let m = (i + j) / 2
        
        if start < m && end < m {
            return partialMax(start: start, end: end, i: i, j: m)
        }
        
        if start >= m && end >= m {
            return partialMax(start: start, end: end, i: m, j: j)
        }
        
        assert(start < m && end >= m)
        
        let left = lookUpMax(start: start, end: m)!
        let right = lookUpMax(start: m, end: end)!
        return max(left, right)
    }
    
    private func fillCache() {
        fillCache(start: 0, end: array.count)
    }
    
    private func fillCache(start: Int, end:Int) {
        guard start < end - 1 else { return }
        
        savePartialMaximumToCache(start: start, end: end)
        
        let mid = (start + end) / 2
        fillCache(start: start, end: mid)
        fillCache(start: mid, end: end)
    }
    
    private func savePartialMaximumToCache(start: Int, end:Int) {
        guard start < end else { return }
        
        let mid = (start + end) / 2
        
        var i = mid - 2
        while i >= 0 {
            cache[Interval(start: i, end: mid)] = max(array[i], lookUpMax(start: i + 1, end: mid)!)
            i -= 1
        }
        
        var j = mid + 2
        while j <= end {
            cache[Interval(start: mid, end: j)] = max(array[j-1], lookUpMax(start: mid, end: j - 1)!)
            j += 1
        }
    }
    
    private func lookUpMax(start: Int, end: Int) -> Element? {
        precondition(start < end)
        
        if end - start == 1 {
            return array[start]
        }
        
        let interval = Interval(start: start, end: end)
        return cache[interval]
    }
    
}
