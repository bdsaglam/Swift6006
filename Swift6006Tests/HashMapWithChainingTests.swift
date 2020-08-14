//
//  HashMapWithChainingTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 14.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006

class HashMapWithChainingTests: XCTestCase {

    func testNonExistingKey() {
        var hashMap = HashMapWithChaining<String, Int>()
        
        XCTAssertEqual(hashMap.count, 0)
        XCTAssertNil(hashMap.get("any"))
        XCTAssertNil(hashMap.get("way"))
    }
    
    func testGetPut() {
        var hashMap = HashMapWithChaining<String, Int>()
        hashMap.put(key: "US", value: 1)
        hashMap.put(key: "TR", value: 90)

        XCTAssertEqual(hashMap.count, 2)
        XCTAssertEqual(hashMap.get("US")!, 1)
        XCTAssertEqual(hashMap.get("TR")!, 90)
        
    }
    
    func testUpdate() {
        var hashMap = HashMapWithChaining<String, Int>()
        hashMap.put(key: "US", value: 1)
        hashMap.put(key: "US", value: 0)
        
        XCTAssertEqual(hashMap.count, 1)
        XCTAssertEqual(hashMap.get("US")!, 0)
    }
    
    func testRemove() {
        var hashMap = HashMapWithChaining<String, Int>()
        hashMap.put(key: "US", value: 1)
        hashMap.put(key: "UK", value: 44)
        hashMap.put(key: "TR", value: 90)
        
        let usCode = hashMap.remove(key: "US")
        let ukCode = hashMap.remove(key: "UK")
        
        XCTAssertEqual(hashMap.count, 1)
        XCTAssertNil(hashMap.get("US"))
        XCTAssertEqual(usCode, 1)
        XCTAssertEqual(ukCode, 44)
    }
    
    func testRemoveFromEmpty() {
        var hashMap = HashMapWithChaining<String, Int>()
        let value = hashMap.remove(key: "any")
        
        XCTAssertEqual(hashMap.count, 0)
        XCTAssertNil(value)
    }
    
    func testCount() {
        var hashMap = HashMapWithChaining<String, Int>()
        hashMap.put(key: "US", value: 1)
        hashMap.put(key: "UK", value: 44)
        hashMap.put(key: "TR", value: 90)
        
        XCTAssertEqual(hashMap.count, 3)
        
        hashMap.put(key: "US", value: 0)
        
        XCTAssertEqual(hashMap.count, 3)
        
        hashMap.remove(key: "US")
        hashMap.remove(key: "UK")
        
        XCTAssertEqual(hashMap.count, 1)
    }
    
    func testTableGrow() {
        var hashMap = HashMapWithChaining<Int, Int>()
        for i in 0..<100 {
            hashMap.put(key: i, value: i*i)
        }
        XCTAssertEqual(hashMap.count, 100)
        
        for (key, value) in hashMap {
            XCTAssertEqual(value, key*key)
        }
    }
    
    func testTableGrowAndShrink() {
        var hashMap = HashMapWithChaining<Int, Int>()
        for i in 0..<100 {
            hashMap.put(key: i, value: i*i)
        }
        XCTAssertEqual(hashMap.count, 100)
        
        // remove first 50 numbers
        for i in 0..<50 {
            hashMap.remove(key: i)
        }
        XCTAssertEqual(hashMap.count, 50)
        
        // add back first 50 numbers
        for i in 0..<50 {
            hashMap.put(key: i, value: -i*i)
        }
        XCTAssertEqual(hashMap.count, 100)
        
        // update last 50 numbers
        for i in 50..<100 {
            hashMap.put(key: i, value: -i*i)
        }
        XCTAssertEqual(hashMap.count, 100)
        
        // check values
        for (key, value) in hashMap {
            XCTAssertEqual(value, -key*key)
        }
    }

}
