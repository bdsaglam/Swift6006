//
//  LinearSortingTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 11.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest

class LinearSortingTests: XCTestCase {

    func testCountingSort(){
        let k = 6
        let array = [
            ("Godfather II", 5),
            ("Shawshank", 0),
            ("Guguk", 4),
            ("Her", 2),
            ("V for Vendetta", 1),
            ("Yol", 3),
            ("Godfather I", 3),
            ("About time", 2),
        ]
        let expected = [
            ("Shawshank", 0),
            ("V for Vendetta", 1),
            ("Her", 2),
            ("About time", 2),
            ("Yol", 3),
            ("Godfather I", 3),
            ("Guguk", 4),
            ("Godfather II", 5),
        ]
        
        let actual = countingSort(array, k:k, by: { $0.1 })
        
        XCTAssert(expected.map{ $0.0}.elementsEqual(actual.map{ $0.0}))
        XCTAssert(expected.map{ $0.1}.elementsEqual(actual.map{ $0.1}))
    }
    
    func testRadixSort(){
        let array = [
           ("Godfather II", 115),
           ("Guguk", 412),
           ("Yol", 315),
           ("Godfather I", 362),
           ("Her", 278),
           ("About time", 235),
           ("V for Vendetta", 191),
           ("Shawshank", 855),
        ]
        let expected = array.sorted { $0.1 < $1.1 }
        let actual = radixSort(array, numDigits: 3) { $0.1 }
        
        XCTAssert(expected.map{ $0.0}.elementsEqual(actual.map{ $0.0}))
        XCTAssert(expected.map{ $0.1}.elementsEqual(actual.map{ $0.1}))
    }
    
    
    func testBucketSort(){
        let array = [12, 5, 58, 85, 34, 20, 89, 4, 95, 77, 56]
        let expected = array.sorted()
        let actual = bucketSort(array, minValue: 0, maxValue: 100)
        
        
        XCTAssert(expected.elementsEqual(actual))
    }
}
