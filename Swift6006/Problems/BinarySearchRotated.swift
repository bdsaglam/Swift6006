//
//  BinarySearchRotated.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 23.02.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//


/**
 Find element in a rotated array that is initially sorted
 Time complexity: O(lg(n))
*/

func binarySearchRotated<T: Comparable>(_ array: [T], _ target: T) -> Int? {
    let k = findRotationCount(array)
    
    if let left = array.binarySearch(target, start: 0, end: k) { return left }
    
    if let right = array.binarySearch(target, start: k, end: array.endIndex) {
        return right
    }
    
    return nil
}

fileprivate func findRotationCount<T: Comparable>(_ array: [T]) -> Int {
    precondition(array.count > 0)
    
    let first = array[0]
    
    var start = 0
    var end = array.count
    
    while start < end {
        let mid = (start + end) / 2
        let median = array[mid]
        
        if median >= first {
            let nextIndex = mid + 1
            guard nextIndex < array.count else { break }
            let next = array[nextIndex]
            if next <= first && next < median {
                return nextIndex
            }
            start = nextIndex
        } else {
            let prevIndex = mid - 1
            guard prevIndex >= 0 else { break }
            let prev = array[prevIndex]
            if prev >= first && prev > median {
                return mid
            }
            end = mid
        }
    }
    
    return 0
}
