//
//  AVLTreeUnitTest.swift
//  AlgorithmsUnitTest
//
//  Created by Barış Deniz Sağlam on 14.01.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import XCTest
@testable import Swift6006


class AVLTreeUnitTest: XCTestCase {

    func testExample() {
        let tree = AVLTree<Int, String>()

        XCTAssert(tree.checkRepInvariance())
        tree.insert(key: 31, value: "Iskenderun")
        XCTAssert(tree.checkRepInvariance())
        tree.insert(key: 23, value: "Elazig")
        XCTAssert(tree.checkRepInvariance())
        tree.insert(key: 6, value: "Ankara")
        XCTAssert(tree.checkRepInvariance())
        tree.insert(key: 34, value: "Istanbul")
        XCTAssert(tree.checkRepInvariance())
        tree.insert(key: 35, value: "Izmir")
        XCTAssert(tree.checkRepInvariance())
        tree.insert(key: 1, value: "Adana")
        XCTAssert(tree.checkRepInvariance())

        print("sorted traversal")
        for (key, value) in tree.traverseInOrder(){
            print(key, value)
        }
        XCTAssert(tree.checkRepInvariance())

        print("breadth first traversal")
        for (key, value) in tree.traverseByLevels().flatMap({ $0 }) {
            print(key, value)
        }
        XCTAssert(tree.checkRepInvariance())

        print("min max operations")
        print(tree.min()!)
        XCTAssert(tree.checkRepInvariance())
        print(tree.max()!)
        XCTAssert(tree.checkRepInvariance())

        print("find operations")
        print(tree.find(key: 5))
        XCTAssert(tree.checkRepInvariance())
        print(tree.find(key: 6))
        XCTAssert(tree.checkRepInvariance())
        print(tree.find(key: 31))
        XCTAssert(tree.checkRepInvariance())
        print(tree.find(key: 34))
        XCTAssert(tree.checkRepInvariance())

        print(tree.findPredecessor(key: 34))
        XCTAssert(tree.checkRepInvariance())
        print(tree.findSuccessor(key: 34))
        XCTAssert(tree.checkRepInvariance())
        
        XCTAssert(tree.root?.min().parent != nil)
        
        print(tree.removeMin())
        XCTAssert(tree.checkRepInvariance())
        print(tree.removeMax())
        XCTAssert(tree.checkRepInvariance())
        print(tree.remove(key: 31))
        XCTAssert(tree.checkRepInvariance())
        
        
    }
    
    func testfindInRangeEmpty() {
        let tree = AVLTree<Int, String>()

        tree.insert(key: 31, value: "Iskenderun")
        tree.insert(key: 23, value: "Elazig")
        tree.insert(key: 6, value: "Ankara")
        tree.insert(key: 34, value: "Istanbul")
        tree.insert(key: 35, value: "Izmir")
        tree.insert(key: 1, value: "Adana")
        XCTAssert(tree.checkRepInvariance())
        
        let expected = [String]()
        
        XCTAssert(tree.checkRepInvariance())
        
        XCTAssert(Array(tree.findInRange(low: 10, high: 20)).map{$0.1}.elementsEqual(expected))
        XCTAssert(Array(tree.findInRange(low: -10, high: 1)).map{$0.1}.elementsEqual(expected))
        XCTAssert(Array(tree.findInRange(low: 36, high: 42)).map{$0.1}.elementsEqual(expected))
        
    }
    
    func testfindInRange() {
        let tree = AVLTree<Int, String>()

        tree.insert(key: 31, value: "Iskenderun")
        tree.insert(key: 23, value: "Elazig")
        tree.insert(key: 6, value: "Ankara")
        tree.insert(key: 34, value: "Istanbul")
        tree.insert(key: 35, value: "Izmir")
        tree.insert(key: 1, value: "Adana")
        XCTAssert(tree.checkRepInvariance())
        
        let expected = ["Ankara", "Elazig"]
        
        let actual = Array(tree.findInRange(low: 2, high: 24)).map{$0.1}.sorted()
        XCTAssert(tree.checkRepInvariance())
        
        XCTAssert(expected.elementsEqual(actual))
        
    }
    
    func testfindInRangeAll() {
        let tree = AVLTree<Int, String>()

        tree.insert(key: 31, value: "Iskenderun")
        tree.insert(key: 23, value: "Elazig")
        tree.insert(key: 6, value: "Ankara")
        tree.insert(key: 34, value: "Istanbul")
        tree.insert(key: 35, value: "Izmir")
        tree.insert(key: 1, value: "Adana")
        XCTAssert(tree.checkRepInvariance())
        
        let expected = ["Ankara", "Elazig", "Iskenderun", "Istanbul", "Izmir", "Adana" ].sorted()
        
        let actual = Array(tree.findInRange(low: 1, high: 36)).map{$0.1}.sorted()
        XCTAssert(tree.checkRepInvariance())
        
        XCTAssert(expected.elementsEqual(actual))
    }

}
