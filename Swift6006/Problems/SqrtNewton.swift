//
//  SqrtNewton.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


func sqrtNewton(_ x: Int, precision: Int = 4) -> (Int, Int) {
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

fileprivate func round(_ x: Int, radix: Int = 10) -> Int {
    let rem = x % radix
    if rem >= radix/2 {
        return x + radix - rem
    }
    return x - rem
}

/**
 This takes more time than Newton.
 Newton takes O(lg(d)) while this binary search takes O(d), where a has d bits.
 
 The idea here is to make an educated initlal guess so that Newton's solver converges in fewer iterations, i.e. faster.
 For sqrt, we do a binary search within 64 bits integer to find an initial guess.
 If a number has N bits, its sqrt cannot have more bits than N/2. So that is our upper bound for binary search.
 */
func sqrtWithBinarySearch(_ a: Int) -> Int {
    var high = 1 << (a.countSignificantBits() / 2 + 1)
    
    while true {
        let mid = high >> 1
        let midsq = mid * mid
        
        if midsq > a {
            high = mid
        } else {
            return mid
        }
    }
    
    fatalError()
}
