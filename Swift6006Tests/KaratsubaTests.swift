//
//  KaratsubaTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 16.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006


class KaratsubaTests: XCTestCase {

    func testBothZero() {
        let x: UInt = 0
        let y: UInt = 0
        XCTAssertEqual(multiplyKaratsuba(x, y), UInt(0))
    }
    
    func testOneZero() {
        let x: UInt = 0
        let y: UInt = 13
        XCTAssertEqual(multiplyKaratsuba(x, y), UInt(0))
    }
    
    func testRandom() {
        let h = UInt(1) << 32
        for _ in 0..<100 {
            let x: UInt = UInt.random(in: 0..<h)
            let y: UInt = UInt.random(in: 0..<h)
            XCTAssertEqual(multiplyKaratsuba(x, y), x * y)
            
        }
    }
    
}
