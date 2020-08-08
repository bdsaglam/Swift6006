//
//  Recitation1.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 8.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


//MARK: - 1D peak finding

/// Checks whether the element at given index is peak or not. A peak is an element that is not less than its left and right neighbors.
/// - Parameters:
///   - array: A non-empty array of integers.
///   - index: index of element
/// - Returns: true if the element at given index is a peak, false otherwise.
func isPeak(_ array:[Int], index: Int) -> Bool {
    precondition(index < array.count)
    return (index == 0 || array[index] >= array[index - 1]) &&
        (index == array.count - 1 || array[index] >= array[index + 1])
}

/// Finds a peak in an array. A peak is an element that is not less than its left and right neighbors. The peak found does not have to be global maximum.
///  Time complexity:         O(lg(n))
///  Memory complexity:    O(1)
/// - Parameter array: A non-empty array of integers.
/// - Returns: index of a peak element
func findAPeak(_ array:[Int]) -> Int {
    return findAPeak(array, array.startIndex, array.endIndex)
}

/// Finds a peak within a given range of an array.
/// - Parameters:
///   - array: A non-empty array of integers.
///   - start: start index of range (inclusive)
///   - end: end index of range (exclusive)
/// - Returns: index of a peak element
func findAPeak(_ array:[Int], _ start:Int, _ end:Int) -> Int {
    precondition(array.count > 0)
    
    // if one-element range, return index of that element
    if end - start <= 1 { return start }
    
    let mid = (start + end) / 2
    if array[mid] < array[mid - 1] {
        return findAPeak(array, start, mid)
    }
    if mid < end - 1 && array[mid] < array[mid + 1] {
        return findAPeak(array, mid + 1, end)
    }
    return mid
}
