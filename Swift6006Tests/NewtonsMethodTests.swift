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

fileprivate func makeUpdateFunctionForSqrt(_ a: Double)
    -> UnivariateNumericFunction
{
    let uf: UnivariateNumericFunction = { x in
        return x / 2 + (a / 2) / x
    }
    return uf
}

fileprivate func makeUpdateFunctionForSqrt(_ a: Int) -> (Int) -> Int {
    let uf: (Int) -> Int = { x in
        return x >> 1 + (a >> 1) / x
    }
    return uf
}

fileprivate func sqrtNewton(_ x: Int, precision: Int = 4) -> (Int, Int) {
    precondition(x >= 0)
    
    if x < 2 { return (x, 0) }
    
    let base = 10
    // get one extra precision so that we can round the result
    let R = x * pow(base: base, exponent: (precision + 1) * 2)
    
    // sqrt of a number have at most half of the bits/digits as the number
    // therefore, it is good to have this as initial guess
    let initialGuess = 1 << (x.countSignificantBits() / 2 - 1)
    var result = try! solveNewton(
        updateFunction: makeUpdateFunctionForSqrt(R),
        initialGuess: initialGuess
    )
    
    // round up the result
    let rem = result % base
    if rem >= (base / 2) {
        result += base - rem
    }
    
    // remove extra precision
    result /= base
    
    // split number into integral and fractional parts
    let k = pow(base: base, exponent: precision)
    let integral = result / k
    let fractional = result % k
    
    return (integral, fractional)
}

fileprivate func round(_ x: Int, radix: Int = 10) -> Int {
    let rem = x % radix
    if rem >= radix/2 {
        return x + radix - rem
    }
    return x - rem
}
