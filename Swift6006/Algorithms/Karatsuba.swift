//
//  Karatsuba.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 16.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

fileprivate extension UnsignedInteger {
    func sliceBits(start: Int, end: Int) -> Self {
        guard start < end else { return Self() }
        guard end < bitWidth else {
            return self >> start
        }
        let mask = (Self(1) << (end - start)) - 1
        return (self >> start) & mask
    }
}

/// Multiplies two unsigned integers with Karatsuba algorithm.
/// Time complexity  : O(n^lg(3))
/// Space complexity: O(n*lg(n))
/// x * y = ( xh * R + xl ) * ( yh * R + xl )
/// R = 2^(N/2)
/// N = bitwidth
/// x * y = xh * yh * R^2 + xh * yl * R + yh * xl * R + xl * yl
/// z0 = xh * yh
/// z2 = xl * yl
/// z1 = xh * yl + yh * xl = (xh + xl) * (yh + yl) - z0 - z2
/// - Parameters:
///   - x: an unsigned integer
///   - y: an unsigned integer
///   - n: max bitwidth for integers
/// - Returns: x*y
func multiplyKaratsuba(_ x: UInt, _ y: UInt, _ n: Int = UInt.bitWidth) -> UInt {
    if x == 0 || y == 0 { return 0 }
    if x == 1 { return y }
    if y == 1 { return x }
    if n == 1 { return x * y }
    
    let mid: Int = n / 2

    let xl = x.sliceBits(start: 0, end: mid)
    let xh = x.sliceBits(start: mid, end: n)
    
    let yl = y.sliceBits(start: 0, end: mid)
    let yh = y.sliceBits(start: mid, end: n)
    
    let z0 = multiplyKaratsuba(xl, yl, mid)
    let z2 = multiplyKaratsuba(xh, yh, mid)
    
    let z1 = (xh + xl) * (yh + yl) - z0 - z2
    
    return z2 << n + z1 << (n/2) + z0
}
