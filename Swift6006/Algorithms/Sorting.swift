//
//  Sorting.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 10.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

// MARK: Insertion sort
func insertionSort<Element: Comparable>(_ array: inout [Element]) {
    if array.count==0 { return }
    
    for i in 1..<array.count {
        var j = i
        while j > 0 && array[j] < array[j - 1]{
            array.swapAt(j, j - 1)
            j -= 1
        }
    }
}

// MARK: Selection sort
func selectionSort<Element: Comparable>(_ array:inout [Element]) {
    if array.count==0 { return }
    
    for i in array.indices {
        var minimumIndex = i
        for j in i+1 ..< array.count {
            if array[j] < array[minimumIndex] {
                minimumIndex = j
            }
        }
        array.swapAt(i, minimumIndex)
    }
}

// MARK: Merge sort

/// Recursive merge sort.
/// - Parameter array: An array of comparable elements
/// - Returns: A sorted copy of input array
func mergeSortRecursive<Element: Comparable >(_ array:[Element]) -> [Element] {
    if array.count == 0 { return array }
    return mergeSortRecursiveHelper(array, start: 0, end: array.count - 1)
}

/// Recursive merge sort helper function that applies it on specified range.
/// - Parameters:
///   - array: An array of comparable elements
///   - start: Start index of range (inclusive)
///   - end: End index of range (inclusive)
/// - Returns: A sorted copy of the range of input array
private func mergeSortRecursiveHelper<Element: Comparable>(
    _ array:[Element],
    start:Int,
    end:Int
) -> [Element] {
    if start == end { return [array[start]] }
    
    let mid = (start + end) / 2 + 1
    let left = mergeSortRecursiveHelper(array, start: start, end: mid - 1)
    let right = mergeSortRecursiveHelper(array, start: mid, end: end)
    return merge(left, right)
}

/// Merges two sorted array into a new sorted one.
/// - Parameters:
///   - left: A sorted array
///   - right: A sorted array
/// - Returns: A sorted array whose elements are from left and right arrays
private func merge<Element: Comparable>(_ left:[Element], _ right:[Element])
    -> [Element] {
    var array = [Element]()
    array.reserveCapacity(left.count + right.count)
    
    var i = 0
    var j = 0
    while i < left.count && j < right.count {
        if left[i] <= right[j] {
            array.append(left[i])
            i += 1
        } else {
            array.append(right[j])
            j += 1
        }
    }
    
    while i < left.count {
        array.append(left[i])
        i += 1
    }
    
    while j < right.count {
        array.append(right[j])
        j += 1
    }
    
    return array
}

/// In-place merge sort
/// It sorts the array in bottom-up fashion. Starts from two element subarrays and doubles size at each step
/// - Parameter array: A reference to an array of comparable elements
func mergeSort<Element: Comparable>(_ array:inout [Element]) {
    if array.count < 2 { return }
    
    // Construct slices at each level of tree, like
    // [0,n)
    // [0, n/2), [n/2, n)
    // [0, n/4), [n/4, n/2), [n/2, 3n/4), [3n/4, n)
    // ...
    var slices = [(0, array.count)]
    var windowStart = 0
    var windowEnd = windowStart + 1

    var sliceSize = array.count / 2
    while sliceSize > 0 {
        var counter = 0
        for (startIndex, endIndex) in slices[windowStart..<windowEnd] {
            let midIndex = (startIndex + endIndex) / 2
            
            slices.append((startIndex, midIndex))
            slices.append((midIndex, endIndex))
            counter += 2
        }
        windowStart = windowEnd
        windowEnd += counter
        sliceSize /= 2
    }
    
    for (startIndex, endIndex) in slices.reversed() {
        mergeSortHelper(&array, startIndex: startIndex, endIndex: endIndex)
    }

}

/// Sorts and merges two halves of a given range in an array
/// - Parameters:
///   - array: A reference to an array of comparable elements
///   - startIndex: Start index of range (inclusive)
///   - endIndex: End index of range (exclusive)
func mergeSortHelper<Element:Comparable>(
    _ array:inout [Element],
    startIndex:Int,
    endIndex:Int
) {
    if (endIndex - startIndex) == 1 {
        return
    }
    if (endIndex - startIndex) == 2 {
        if array[startIndex] > array[endIndex - 1] {
            array.swapAt(startIndex, endIndex - 1)
        }
        
        return
    }
    
    let buffer = Array(array[startIndex..<endIndex])
    let midIndex = buffer.count/2
    var i = 0
    var j = midIndex
    var k = startIndex
        
    while i < midIndex  && j < buffer.count {
        if buffer[i] <= buffer[j] {
            array[k] = buffer[i]
            i += 1
        } else {
            array[k] = buffer[j]
            j += 1
        }
        k += 1
    }
    
    while i < midIndex {
        array[k] = buffer[i]
        i += 1
        k += 1
    }
    
    while j < buffer.count {
        array[k] = buffer[j]
        j += 1
        k += 1
    }
    
}



// MARK: Quick Sort
/**
 in quick sort, we take last element of array as pivot, and apply partition and get new pivot,
 then recursively apply quick sort algorithm to the left and right subarrays.

 In partition operation, we organize the array such that smaller elements stay left of the pivot
 while larger elements stay right of the pivot. To do that, we have two pointers i and j;
 i representing beginning of larger elements, j representing the end of larger elements
 Whenever we encounter an element larger than pivot, we increase j by 1.
 Whenever we encounter an element smaller than pivot, we swap it with ith element and then
 increase i and j by 1. At the last step, we swap ith element with pivot.
 */
func partition<Element: Comparable>(
    _ array:inout Array<Element>,
    from p: Int,
    to r: Int
) -> Int {
    let pivot = array[r]
    
    var i = p
    var j = p
    while j < r {
        if array[j] < pivot {
            array.swapAt(i, j)
            i += 1
        }
        j += 1
    }
    array.swapAt(i, r)
    return i
}

private func quickSortHelper<Element: Comparable>(
    _ array: inout Array<Element>,
    from start: Int,
    to end:Int
) {
    guard start < end else { return }
    
    let q = partition(&array, from: start, to: end)
    quickSortHelper(&array, from: start, to: q - 1)
    quickSortHelper(&array, from: q + 1, to: end)
}

func quickSort<Element: Comparable>(_ array: inout Array<Element>) {
    quickSortHelper(&array, from: 0, to: array.count - 1)
}

func quickSortProactive<Element: Comparable>(_ array: inout Array<Element>) {
    if array.isSorted() { return }
    array.shuffle()
    quickSortHelper(&array, from: 0, to: array.count - 1)
}


// MARK: Heap sort

func heapSort<Element: Comparable>(_ array:[Element]) -> [Element] {
    let heap = ArrayHeap(from: array, by: <)
    return Array(heap)
}

func heapSort<Element>(
    _ array:[Element],
    by areInIncreasingOrder: @escaping (Element, Element) -> Bool
) -> [Element]
{
    let heap = ArrayHeap(from: array, by: areInIncreasingOrder)
    return Array(heap)
}


