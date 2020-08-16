//
//  BSTUnitTest.swift
//  AlgorithmsUnitTest
//
//  Created by Barış Deniz Sağlam on 29.12.2019.
//  Copyright © 2019 Barış Deniz Sağlam. All rights reserved.
//

import XCTest
@testable import Swift6006


class BSTUnitTest: XCTestCase {

    func testExample() {
        let bst = BinarySearchTree<Int, String>()

        XCTAssert(bst.checkRepInvariance())
        bst.insert(key: 31, value: "Iskenderun")
        XCTAssert(bst.checkRepInvariance())
        bst.insert(key: 23, value: "Elazig")
        XCTAssert(bst.checkRepInvariance())
        bst.insert(key: 6, value: "Ankara")
        XCTAssert(bst.checkRepInvariance())
        bst.insert(key: 34, value: "Istanbul")
        XCTAssert(bst.checkRepInvariance())
        bst.insert(key: 35, value: "Izmir")
        XCTAssert(bst.checkRepInvariance())
        bst.insert(key: 1, value: "Adana")
        XCTAssert(bst.checkRepInvariance())

        print("sorted traversal")
        for (key, value) in bst.traverseInOrder(){
            print(key, value)
        }
        XCTAssert(bst.checkRepInvariance())

        print("breadth first traversal")
        for (key, value) in bst.traverseByLevels().flatMap({ $0 }) {
            print(key, value)
        }
        XCTAssert(bst.checkRepInvariance())

        print("min max operations")
        print(bst.min()!)
        XCTAssert(bst.checkRepInvariance())
        print(bst.max()!)
        XCTAssert(bst.checkRepInvariance())

        print("find operations")
        print(bst.find(key: 5))
        XCTAssert(bst.checkRepInvariance())
        print(bst.find(key: 6))
        XCTAssert(bst.checkRepInvariance())
        print(bst.find(key: 31))
        XCTAssert(bst.checkRepInvariance())
        print(bst.find(key: 34))
        XCTAssert(bst.checkRepInvariance())

        print(bst.findPredecessor(key: 34))
        XCTAssert(bst.checkRepInvariance())
        print(bst.findSuccessor(key: 34))
        XCTAssert(bst.checkRepInvariance())
        
        XCTAssert(bst.root?.min().parent != nil)
        
        print(bst.removeMin())
        XCTAssert(bst.checkRepInvariance())
        print(bst.removeMax())
        XCTAssert(bst.checkRepInvariance())
        print(bst.remove(key: 31))
        XCTAssert(bst.checkRepInvariance())
        
        
    }
    
    func testfindInRangeEmpty() {
        let bst = BinarySearchTree<Int, String>()

        bst.insert(key: 31, value: "Iskenderun")
        bst.insert(key: 23, value: "Elazig")
        bst.insert(key: 6, value: "Ankara")
        bst.insert(key: 34, value: "Istanbul")
        bst.insert(key: 35, value: "Izmir")
        bst.insert(key: 1, value: "Adana")
        XCTAssert(bst.checkRepInvariance())
        
        let expected = [String]()
        
        XCTAssert(bst.checkRepInvariance())
        
        XCTAssert(Array(bst.findInRange(low: 10, high: 20)).map{$0.1}.elementsEqual(expected))
        XCTAssert(Array(bst.findInRange(low: -10, high: 1)).map{$0.1}.elementsEqual(expected))
        XCTAssert(Array(bst.findInRange(low: 36, high: 42)).map{$0.1}.elementsEqual(expected))
        
    }
    
    func testfindInRange() {
        let bst = BinarySearchTree<Int, String>()

        bst.insert(key: 31, value: "Iskenderun")
        bst.insert(key: 23, value: "Elazig")
        bst.insert(key: 6, value: "Ankara")
        bst.insert(key: 34, value: "Istanbul")
        bst.insert(key: 35, value: "Izmir")
        bst.insert(key: 1, value: "Adana")
        XCTAssert(bst.checkRepInvariance())
        
        let expected = ["Ankara", "Elazig"]
        
        let actual = Array(bst.findInRange(low: 2, high: 24)).map{$0.1}.sorted()
        XCTAssert(bst.checkRepInvariance())
        
        XCTAssert(expected.elementsEqual(actual))
        
    }
    
    func testfindInRangeAll() {
        let bst = BinarySearchTree<Int, String>()

        bst.insert(key: 31, value: "Iskenderun")
        bst.insert(key: 23, value: "Elazig")
        bst.insert(key: 6, value: "Ankara")
        bst.insert(key: 34, value: "Istanbul")
        bst.insert(key: 35, value: "Izmir")
        bst.insert(key: 1, value: "Adana")
        XCTAssert(bst.checkRepInvariance())
        
        let expected = ["Ankara", "Elazig", "Iskenderun", "Istanbul", "Izmir", "Adana" ].sorted()
        
        let actual = Array(bst.findInRange(low: 1, high: 36)).map{$0.1}.sorted()
        XCTAssert(bst.checkRepInvariance())
        
        XCTAssert(expected.elementsEqual(actual))
    }

}
