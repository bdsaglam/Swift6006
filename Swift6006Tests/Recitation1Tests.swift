//
//  Recitation1Tests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 8.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006


class PeakFinding1D: XCTestCase {
    func testOneElementArray() throws {
        let array:[Int] = [0]
        XCTAssertEqual(0, findAPeak(array))
    }
    
    func testArrayWithSameElement() throws {
        let array:[Int] = Array(repeating: 7, count: 9)
        XCTAssertTrue(isPeak(array, index: findAPeak(array)))
    }
    
    func testMonotonicallyIncresingArray() throws {
        let array:[Int] = Array(0..<100)
        XCTAssertEqual(array.endIndex - 1, findAPeak(array))
    }
    
    func testMonotonicallyDecreasingArray() throws {
        let array:[Int] = Array(0..<100).reversed()
        XCTAssertEqual(0, findAPeak(array))
    }
    
    func testRandomArrays() throws {
        for _ in 0 ..< 10 { // for 10 different sizes
            let size = Int.random(in: 1 ..< 100)
            for _ in 0 ..< 100 {
                let array = (0 ..< size).map { i in Int.random(in: 0..<100) }
                let peakIndex = findAPeak(array)
                XCTAssertTrue(isPeak(array, index: peakIndex), "\(array) \(peakIndex)")
                
            }
        }
    }



}
