//
//  MathUtils.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 16.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


func gcd(_ a: Int, _ b: Int) -> Int {
    if a == 0 { return b }
    
    return gcd(b % a, a)
}

func modularInverse(of dividend: Int, divisor: Int) -> Int {
    precondition(gcd(dividend, divisor) == 1)
    
    return pow(base: dividend, exponent: divisor - 2, divisor: divisor)
}

func pow(base: Int, exponent: Int, divisor: Int) -> Int {
    if exponent == 1 { return base % divisor }
        
    var p = pow(base:base, exponent:exponent / 2, divisor: divisor)
    p = (p * p) % divisor
    
    if exponent % 2 == 0 {
        return p
    }
    
    return (base * p) % divisor
}

func pow(base: Int, exponent: Int) -> Int {
    precondition(exponent >= 0)
    if exponent == 0 { return 1 }
    if exponent == 1 { return base }
        
    let hp = pow(base: base, exponent: exponent / 2)
    let p = hp * hp
    
    if exponent % 2 == 0 {
        return p
    }
    
    return p * base
}
