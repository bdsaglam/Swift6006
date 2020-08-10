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
///  Time complexity  : O(lg(n))
///  Space complexity: O(1)
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

//MARK: - 2D peak finding

/// Checks whether the element at given index is 2D peak or not. A 2D peak is an element that is not less than its adjacents.
/// - Parameters:
///   - arr: A non-empty 2D array of integers.
///   - index: index of element
/// - Returns: true if the element at given index is a peak, false otherwise.
func isPeak2D<T: Comparable>(_ array: Array2D<T>, row: Int, col: Int) -> Bool {
    precondition(array.isIndexValid(row, col))
    
    let left = col == 0 ? true : array[row, col] >= array[row, col-1]
    let right = col == array.ncol - 1 ? true : array[row, col] >= array[row, col+1]
    let up = row == 0 ? true : array[row, col] >= array[row-1, col]
    let down = row == array.nrow - 1 ? true : array[row, col] >= array[row+1, col]
    return left && right && up && down
}

/// Finds a peak in a 2D array. A peak is an element that is not less than its adjacent elements. The peak found does not have to be global maximum.
///  Time complexity  : O(nlg(n))
///  Space complexity: O(1)
/// - Parameter array: A non-empty 2D array of integers.
/// - Returns: index of a peak element
func findA2DPeakSlow<T: Comparable>(_ array: Array2D<T>) -> (row:Int, col:Int) {
    return findA2DPeakSlow(array, startCol: 0, endCol: array.ncol)
}

/// Finds a peak within a given column range of a 2D array.
///  Time complexity  : O(nlg(n))
///  Space complexity: O(1)
/// - Parameters:
///   - array: A non-empty 2D array of integers.
///   - startCol: start column index of range (inclusive)
///   - endCol: end column index of range (exclusive)
/// - Returns: row and column indices of a peak element
func findA2DPeakSlow<T: Comparable>(_ array: Array2D<T>, startCol:Int, endCol:Int)
    -> (row:Int, col:Int) {
    precondition(array.count > 0)
    
    let midCol = (startCol + endCol) / 2
    
    let row = array[nil, midCol].argmax()!
    if endCol - startCol <= 1 {
        return (row: row, col:startCol)
    }
    
    let element = array[row, midCol]
    
    if element < array[row, midCol - 1] {
        return findA2DPeakSlow(array, startCol: startCol, endCol: midCol)
    }
    if midCol < endCol - 1 && element < array[row, midCol + 1] {
        return findA2DPeakSlow(array, startCol: midCol + 1, endCol: endCol)
    }
    
    return (row: row, col:midCol)
}

/// Finds a peak in a 2D array. A peak is an element that is not less than its adjacent elements. The peak found does not have to be global maximum.
///  Time complexity  : O(n)
///  Space complexity: O(1)
/// - Parameter v: A non-empty 2D array of integers.
/// - Returns: index of a peak element
func findA2DPeak<T: Comparable>(_ array: Array2D<T>) -> (row:Int, col:Int) {
    return findA2DPeak(
        array,
        splitAlongRow: true,
        firstRow: 0,
        lastRow: array.nrow - 1,
        firstCol: 0,
        lastCol: array.ncol - 1
    )
}

/// Finds a peak within a given column range of a 2D array.
///  Time complexity  : O(nlg(n))
///  Space complexity: O(1)
/// - Parameters:
///   - array: A non-empty 2D array of integers.
///   - startCol: start column index of range (inclusive)
///   - endCol: end column index of range (exclusive)
/// - Returns: row and column indices of a peak element
private func findA2DPeak<T: Comparable>(
    _ array:Array2D<T>,
    splitAlongRow: Bool,
    firstRow:Int,
    lastRow:Int,
    firstCol:Int,
    lastCol:Int) -> (row:Int, col:Int) {
    
    if splitAlongRow {
        let midRow = (firstRow + lastRow) / 2
        let maxCol = array[midRow].argmax()!
        if firstRow == lastRow {
            return (row: firstRow, col:maxCol)
        }
        
        let element = array[midRow, maxCol]
        if midRow > 0 && element < array[midRow - 1, maxCol] {
            return findA2DPeak(
                array,
                splitAlongRow: false,
                firstRow: firstRow,
                lastRow: midRow - 1,
                firstCol: firstCol,
                lastCol: lastCol
            )
        }
        if midRow < array.nrow - 1 && element < array[midRow + 1, maxCol] {
            return findA2DPeak(
                array,
                splitAlongRow: false,
                firstRow: midRow + 1,
                lastRow: lastRow,
                firstCol: firstCol,
                lastCol: lastCol
            )
        }
        
        return (row: midRow, col:maxCol)
    } else {
        let midCol = (firstCol + lastCol) / 2
        let maxRow = array[nil, midCol].argmax()!
        if firstCol == lastCol {
            return (row: maxRow, col:firstCol)
        }
        
        let element = array[maxRow, midCol]
        if midCol > 0 && element < array[maxRow, midCol - 1]{
            return findA2DPeak(
               array,
               splitAlongRow: true,
               firstRow: firstRow,
               lastRow: lastRow,
               firstCol: firstCol,
               lastCol: midCol - 1
           )
        }
        if midCol < array.ncol - 1 && element < array[maxRow, midCol + 1] {
            return findA2DPeak(
               array,
               splitAlongRow: true,
               firstRow: firstRow,
               lastRow: lastRow,
               firstCol: midCol + 1,
               lastCol: lastCol
           )
        }
        return (row: maxRow, col:midCol)
    }
}





