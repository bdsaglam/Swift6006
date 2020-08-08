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
///  Time complexity:       O(lg(n))
///  Memory complexity:  O(1)
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

func max(_ matrix:[[Int]], column: Int) -> Int {
    let nrows = matrix.count
    var maxValue = Int.min
    var rowIndex = -1
    for i in 0 ..< nrows {
        let element = matrix[i][column]
        if element > maxValue {
            rowIndex = i
            maxValue = element
        }
    }
    
    return rowIndex
}

// O(nlog(n))
func findA2DPeak(_ matrix:[[Int]]) -> (row:Int, col:Int) {
    let ncols = matrix[0].count
    return findA2DPeakHelper(matrix, firstCol: 0, lastCol: ncols - 1)
}

private func findA2DPeakHelper(_ matrix:[[Int]], firstCol:Int, lastCol:Int) -> (row:Int, col:Int) {
    let midCol = (firstCol + lastCol) / 2
    let rowIndex = max(matrix, column: midCol)
    if firstCol == lastCol {
        return (row: rowIndex, col:firstCol)
    }
    
    let row = matrix[rowIndex]
    let element = row[midCol]
    
    
    if element < row[midCol - 1] {
        return findA2DPeakHelper(matrix, firstCol: firstCol, lastCol: midCol - 1)
    } else if element < row[midCol + 1] {
        return findA2DPeakHelper(matrix, firstCol: midCol + 1, lastCol: lastCol)
    } else {
        return (row: rowIndex, col:midCol)
    }
}

//// O(n)
//func findA2DPeakBetter(_ matrix:Matrix<Int>) -> (row:Int, col:Int) {
//    return findA2DPeakHelperBetter(
//        matrix,
//        rowSplit:true,
//        firstRow: 0,
//        lastRow: matrix.nrows - 1,
//        firstCol: 0,
//        lastCol: matrix.ncols - 1
//    )
//}
//
//private func findA2DPeakHelperBetter(_ matrix:Matrix<Int>,
//                        rowSplit:Bool,
//                        firstRow:Int,
//                        lastRow:Int,
//                        firstCol:Int,
//                        lastCol:Int) -> (row:Int, col:Int) {
//
//    if rowSplit {
//        let mid = (firstRow + lastRow) / 2
//        let (rowIndex, colIndex) = matrix.argmax(along: .row, index: mid)
//        if firstRow == lastRow {
//            return (row: firstRow, col:colIndex)
//        }
//        let bests = matrix[nil, colIndex]
//        let greatestElement = bests[rowIndex]
//
//        if greatestElement < bests[mid - 1] {
//            return findA2DPeakHelperBetter(
//                matrix,
//                rowSplit: false,
//                firstRow: firstRow,
//                lastRow: mid - 1,
//                firstCol: firstCol,
//                lastCol: lastCol
//            )
//        } else if greatestElement < bests[mid + 1] {
//            return findA2DPeakHelperBetter(matrix,
//            rowSplit: false,
//            firstRow: mid + 1,
//            lastRow: lastRow,
//            firstCol: firstCol,
//            lastCol: lastCol)
//        } else {
//            return (row: rowIndex, col:colIndex)
//        }
//    } else {
//        let mid = (firstCol + lastCol) / 2
//        let (rowIndex, colIndex) = matrix.argmax(along: .column, index: mid)
//        if firstCol == lastCol {
//            return (row: rowIndex, col:firstCol)
//        }
//
//        let bests = matrix[rowIndex, nil]
//        let greatestElement = bests[colIndex]
//
//        if greatestElement < bests[mid - 1] {
//            return findA2DPeakHelperBetter(
//               matrix,
//               rowSplit: true,
//               firstRow: firstRow,
//               lastRow: lastRow,
//               firstCol: firstCol,
//               lastCol: mid - 1
//           )
//        } else if greatestElement < bests[mid + 1] {
//            return findA2DPeakHelperBetter(
//               matrix,
//               rowSplit: true,
//               firstRow: firstRow,
//               lastRow: lastRow,
//               firstCol: mid + 1,
//               lastCol: lastCol
//           )
//        } else {
//            return (row: rowIndex, col:colIndex)
//        }
//    }
//
//
//}
//
//



