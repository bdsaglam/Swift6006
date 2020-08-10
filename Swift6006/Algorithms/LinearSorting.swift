//
//  LinearSorting.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 10.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

// MARK: Counting sort

/// Counting sort.
/// It's a linear sorting algorithms, suitable when the number of distinct element values, k,  is finite and known.
/// First, it counts the occurrences for every value, then by starting from the end of the array, it places elements.
/// - Parameters:
///   - array: An array
///   - k: Number of distinct values of elements after transformation
///   - transform: A function to map elements to values (or bucket ids)
/// - Returns: Stable sorted copy of input array
func countingSort<Element>(
    _ array:[Element],
    k:Int,
    by transform: (Element) -> Int
) -> [Element]
{
    // compute counts of elements in array
    var c = Array(repeating: 0, count: k)
    for element in array {
        let index = transform(element)
        c[index] = c[index] + 1
    }
    
    // derive last indices for each value (bucket)
    c[0] = c[0] - 1
    for i in 1..<c.count {
        c[i] = c[i] + c[i - 1]
    }
    
    // For stability, we must iterate by starting from the end, because
    // a position in c represents the index of last element for that bucket,
    // therefore, we need to put the right most element in the array first and
    // then, decrease index of the bucket and continue
    var result = array
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

// MARK: Radix sort

/// Radix sort.
/// A linear sorting algorithm for integers. Instead of comparing elements, it compares the digits of elements.
/// It applies counting sort to elements by starting from the left-most digit.
/// - Parameters:
///   - array: An array of elements mappable to integer
///   - numDigits: Number of digits for elements after transformation
///   - base: Number of distinct digits
///   - transform: A function to map each element to an integer
/// - Returns: Stable sorted copy of input array
func radixSort<Element>(
    _ array: [Element],
    numDigits: Int,
    base:Int = 10,
    by transform: (Element) -> Int
) -> [Element] {
    var array = array
    for i in 0..<numDigits {
        array = countingSort(array, k: base) { transform($0).digit(at: i)}
    }
    
    return array
}

func radixSort(_ array: [Int], numDigits: Int, base:Int = 10) -> [Int] {
    return radixSort(array, numDigits: numDigits, base: base) { $0 }
}

// MARK: Bucket sort

/// - Parameters:
///   - array: An array of integers
///   - minValue: minimum element in the array
///   - maxValue: maximum element in the array
/// - Returns: A sorted copy of input array
func bucketSort<T: BinaryInteger>(_ array: [T], minValue: T, maxValue: T) -> [T] {
    var buckets = Array(repeating: [T](), count: array.count)
    
    let interval = maxValue - minValue + 1
    for element in array {
        let index = array.count * Int((element - minValue)) / Int(interval)
        buckets[index].append(element)
    }
    
    var result = [T]()
    result.reserveCapacity(array.count)
    
    for var bucket in buckets {
        // since elements in a bucket are similar in magnitude
        // insertion sort is fast
        insertionSort(&bucket)
        result.append(contentsOf: bucket)
    }
    
    return result
}
