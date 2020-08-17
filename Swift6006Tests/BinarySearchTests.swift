//
//  BinarySearchTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006


class BinarySearchTests: XCTestCase {

    func testEmptyCollection() throws {
        let col = [Int]()
        let target = 1
        
        XCTAssertNil(col.binarySearch(target))
    }
    
    func testOneElementCollectionContainsTarget() throws {
        let col = [1]
        let target = 1
        let index = col.binarySearch(target)
        XCTAssertEqual(index, 0)
    }
    
    func testCollectionContainsTarget() throws {
        let col = "abcde"
        let target: Character = "b"
        let index = col.binarySearch(target)
        
        XCTAssertEqual(index, col.index(after: col.startIndex))
    }
    
    func testCollectionDoesNotContainTarget() throws {
        let col = [1,2,3]
        
        XCTAssertNil(col.binarySearch(-1))
        XCTAssertNil(col.binarySearch(0))
        XCTAssertNil(col.binarySearch(4))
    }
    
    func testUnSortedCollection() throws {
        let col = [1,3,2,5,1,2,4,7,8,0]
        // should finish without error
        let index = col.binarySearch(4)
    }

}
