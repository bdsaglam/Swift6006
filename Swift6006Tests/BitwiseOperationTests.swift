//
//  BitwiseOperationTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 14.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006

class BitwiseOperationTests: XCTestCase {
    func testBitAtIndexWithZero() {
        let number: Int8 = 0
        for i in 0..<number.bitWidth {
            XCTAssertEqual(number.bit(at: i), 0)
        }
    }
    
    func testBitAtIndexWithPositiveNumber() {
        let number: Int8 = 0b101
        
        XCTAssertEqual(number.bit(at: 0), 1)
        XCTAssertEqual(number.bit(at: 1), 0)
        XCTAssertEqual(number.bit(at: 2), 1)
        
        for i in 3..<number.bitWidth {
            XCTAssertEqual(number.bit(at: i), 0)
        }
    }
    
    func testBitAtIndexWithNegativeNumber() {
        let number: Int8 = Int8(bitPattern: 0b10000101)
        
        XCTAssertEqual(number.bit(at: 0), 1)
        XCTAssertEqual(number.bit(at: 1), 0)
        XCTAssertEqual(number.bit(at: 2), 1)
        XCTAssertEqual(number.bit(at: 7), 1)
        
        for i in 3..<number.bitWidth-1 {
            XCTAssertEqual(number.bit(at: i), 0)
        }
    }
    
    func testBitsWithZero() {
        let number: Int8 = 0
        let bitz = number.bits()
        let expected = Array<UInt8>(repeating: 0, count: number.bitWidth)
        
        XCTAssertEqual(bitz, expected)
    }
    
    func testBitsWithPositiveNumber() {
        let number: Int8 = 0b101
        let bitz = number.bits()
        let expected: [UInt8] = [0,0,0,0,0,1,0,1]
        
        XCTAssertEqual(bitz, expected)
    }
    
    func testBitsWithNegativeNumber() {
        let number: Int8 = Int8(bitPattern: 0b10000101)
        let bitz = number.bits()
        let expected: [UInt8] = [1,0,0,0,0,1,0,1]
        
        XCTAssertEqual(bitz, expected)
    }
    
    func testBinaryRepresentationOfUnsignedInteger(){
        for _ in 0..<100 {
            let number = UInt8.random(in: 0...255)
            let br = number.binaryRepresentation()
            XCTAssertEqual(UInt8(br, radix: 2), number)
        }
    }
    
    func testBinaryRepresentationOfSignedInteger(){
        for _ in 0..<100 {
            let number = Int8.random(in: -128...127)
            let br = number.binaryRepresentation()
            let recons = Int8(bitPattern: UInt8(br, radix: 2)!)
            XCTAssertEqual(recons, number)
        }
    }
}
