//
//  BitwiseOperations.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 16.02.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


extension BinaryInteger {
    func bit(at index: Int) -> UInt8 {
        precondition(index < bitWidth)
        if index == bitWidth - 1 {
            return signum() == -1 ? 1: 0
        }
        let mask = Self(1) << index
        return (self & mask) > 0 ? 1 : 0
    }
    
    func bits() -> [UInt8] {
        var bitArray: [UInt8] = Array.init(repeating: UInt8(0), count: bitWidth)
        var number = self
        var index = bitArray.count - 1
        while index >= 0 {
            bitArray[index] = UInt8(number & 1)
            number >>= 1
            index -= 1
        }
        return bitArray
    }
    
    func binaryRepresentation(trimLeadingZeros: Bool = true) -> String {
        var bitz = bits()
        if trimLeadingZeros {
            bitz = Array(bitz.drop{ $0==0 })
        }
        if bitz.isEmpty { return "0" }
        return bitz.map{ "\($0)" }.joined(separator: "")
    }
    
}

extension UnsignedInteger {
    func countSignificantBits() -> Int {
        let bitz = bits()
        return bitz.count - bitz.prefix { $0==0 }.count
    }
    
    static func from<C: Collection>(bits: C) -> Self
        where C.Element==UInt8
    {
        return bits.reduce(Self()) { (acc, bit) -> Self in
            return acc << 1 + Self(exactly: bit)!
        }
    }
}

extension SignedInteger where Self: FixedWidthInteger {
    func countSignificantBits() -> Int {
        let bitz = bits()[1...]
        return bitz.count - bitz.prefix { $0==0 }.count
    }

    static func from<C: Collection>(bits: C) -> Self
        where C.Element==UInt8
    {
        guard !bits.isEmpty else { return Self() }
        
        let signBit = bits.first!
        let bitz = bits.dropFirst()
        let number: Self = bitz.reduce(Self()) { (acc, bit) -> Self in
            return acc << 1 + Self(bit)
        }
        return signBit > 0 ? number + min : number
    }
}
