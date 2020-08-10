//
//  LinearSorting.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 10.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

// MARK: Linear Sorting Algorithms

// Counting sort
func countSort<Element>(_ array:[Element], k:Int, by transform: (Element) -> Int) -> [Element] {
    // compute counts of elements in array
    var c = Array(repeating: 0, count: k)
    for element in array {
        let index = transform(element)
        c[index] = c[index] + 1
    }
    
    // derive positions from counts
    c[0] = c[0] - 1
    for i in 1..<c.count {
        c[i] = c[i] + c[i - 1]
    }
    
    var result = array
    
    // for stability, we must iterate from end because
    // a position in c represents the index of last element for that bucket, therefore,
    // we need to put the right most element in the array first and then
    // decrease index and continue
    var j = array.count
    while j > 0 {
        j -= 1
        let element = array[j]
        let index = transform(element)
        let address = c[index]
        result[address] = element
        c[index] = address - 1
    }
    
    return result
}


// Radix sort
func radixSort<Element>(_ array: [Element],
                        numDigits: Int,
                        base:Int = 10,
                        by transform: (Element) -> Int) -> [Element] {
    var array = array
    for i in 0..<numDigits {
        array = countSort(array, k: base) { transform($0).digit(at: i)}
    }
    
    return array
}

func radixSort(_ array: [Int], numDigits: Int, base:Int = 10) -> [Int] {
    return radixSort(array, numDigits: numDigits, base: base) { $0 }
}

// Bucket sort
/// bounds are exclusive
func bucketSort(_ array: [Int], lowerBound:Int, upperBound:Int) -> [Int] {
    var buckets = Array(repeating: [Int](), count: array.count)
    
    let interval = upperBound - lowerBound
    for element in array {
        let index = array.count * element / interval
        buckets[index].append(element)
    }
    
    var result = [Int]()
    result.reserveCapacity(array.count)
    
    for var bucket in buckets {
        insertionSort(&bucket)
        result.append(contentsOf: bucket)
    }
    
    return result
}

/// bounds are exclusive
func bucketSort(_ array: [Double], lowerBound: Double, upperBound: Double) -> [Double] {
    var buckets = Array(repeating: [Double](), count: array.count)
    
    let interval = upperBound - lowerBound
    for element in array {
        let index = array.count * Int(element / interval)
        buckets[index].append(element)
    }
    
    var result = [Double]()
    result.reserveCapacity(array.count)
    
    for var bucket in buckets {
        insertionSort(&bucket)
        result.append(contentsOf: bucket)
    }
    
    return result
}
