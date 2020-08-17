//
//  NewtonsMethodTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 16.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006


class NewtonsMethodTests: XCTestCase {

    func testNewtonMethodForSqrt() {
        for _ in 0..<100 {
            let n = Int.random(in: 0 ..< (1 << 16))

            let radix = 10
            let precision = 4
            let root = sqrt(Double(n))
            // split the root into integral and fractional parts
            let k = pow(base: radix, exponent: precision)
            let result = Int((root * Double(k)))
            let expectedIntegral = result / k
            let expectedFractional = result % k

            let (integral, fractional) = sqrtNewton(n, precision: precision)
            print("")
            XCTAssertEqual(integral, expectedIntegral, "\(n)")
            XCTAssertTrue(abs(fractional - expectedFractional) <= 1)
        }
    }
}
