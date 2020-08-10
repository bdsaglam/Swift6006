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
    
    func testMonotonicallyIncreasingArray() throws {
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
                let array = (0 ..< size).map{ i in Int.random(in: -100..<100) }
                let peakIndex = findAPeak(array)
                XCTAssertTrue(isPeak(array, index: peakIndex),
                              "\(array) \(peakIndex)")
                
            }
        }
    }

}

protocol BasePeakFinding2DTestCase {
    var peakFinder: (Array2D<Int>) -> (Int, Int) { get }
}

extension BasePeakFinding2DTestCase {
    func testSpecific() throws {
        let data: [[Int]] = [
            [2, 1, 0],
            [-9, 3, -1]
        ]
        let arr = Array2D(data)
        
        let (r, c) = peakFinder(arr)
        XCTAssertTrue(isPeak2D(arr, row: r, col: c))
    }
    
    func testRandom2DArrays() throws {
        for _ in 0..<10 { // 10 different shape
            let nrow = Int.random(in: 1..<10)
            let ncol = Int.random(in: 1..<10)
            let size = nrow * ncol
            for _ in 0..<100 {
                let data = (0 ..< size).map { i in Int.random(in: -100..<100) }
                let arr = Array2D(data: data, shape: (nrow, ncol))
                
                let (r,c) = peakFinder(arr)
                XCTAssertTrue(isPeak2D(arr, row: r, col: c))
            }
        }
    }
}
    
class PeakFinding2DSlow: XCTestCase, BasePeakFinding2DTestCase {
    let peakFinder: (Array2D<Int>) -> (Int, Int) = findA2DPeakSlow
}

class PeakFinding2D: XCTestCase, BasePeakFinding2DTestCase {
    let peakFinder: (Array2D<Int>) -> (Int, Int) = findA2DPeak
}
