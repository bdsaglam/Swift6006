//
//  SortingTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 10.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006


class SortingUnitTest: XCTestCase {
    let sizes = Array(stride(from: 0, to: 100, by: 10)) +
        Array(stride(from: 100, to: 1000, by: 100))
    let numberRange = 0..<100
    
    func makeRandomArray(size: Int) -> [Int] {
        return (0..<size).map { i in Int.random(in: numberRange) }
    }
    
    func testIsSorted() {
        for n in sizes {
            var array = makeRandomArray(size: n)
            array.sort()
            XCTAssertTrue(array.isSorted())
        }
    }
    
    func testInsertionSort() {
        for n in sizes {
            var array = makeRandomArray(size: n)
            insertionSort(&array)
            XCTAssertTrue(array.isSorted())
        }
    }
    
    func testSelectionSort() {
        for n in sizes {
            var array = makeRandomArray(size: n)
            selectionSort(&array)
            XCTAssertTrue(array.isSorted())
        }
    }
    
    func testMergeSortRecursive() {
        for n in sizes {
            let array = makeRandomArray(size: n)
            let actual = mergeSortRecursive(array)
            XCTAssertTrue(actual.isSorted())
        }
    }
    
    func testMergeSort(){
        for n in sizes {
            var array = makeRandomArray(size: n)
            mergeSort(&array)
            XCTAssertTrue(array.isSorted())
        }
    }
    
    func testQuickSort(){
        for n in sizes {
            var array = makeRandomArray(size: n)
            quickSort(&array)
            XCTAssertTrue(array.isSorted())
        }
    }
    
    func testHeapSort(){
        for n in sizes {
            let array = makeRandomArray(size: n)
            let actual = heapSort(array)
            XCTAssertTrue(actual.isSorted())
        }
    }

}
