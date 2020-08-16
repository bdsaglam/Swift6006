//
//  LinkedListTests.swift
//  Swift6006Tests
//
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006


class LinkedListTest: XCTestCase {
   
    func testEmptyInitializer() {
        let list = LinkedList<Int>()
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
    }
    
    func testSequenceInitializer() {
        let list = LinkedList<Int>(1...4)
        
        XCTAssertEqual(list.count, 4)
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.first!, 1)
        XCTAssertEqual(list.last!, 4)
    }
    
    func testArrayLiteralInitializer() {
        let list: LinkedList<Int> = [1,2,3,4]
        
        XCTAssertEqual(list.count, 4)
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.first!, 1)
        XCTAssertEqual(list.last!, 4)
    }
    
    func testOneElementList() {
        let list: LinkedList<Int> = [1]
        
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.count, 1)
        XCTAssertNotNil(list.first)
        XCTAssertNotNil(list.last)
        XCTAssertTrue(list.first! == list.last!)
    }
    
    func testTwoElementList() {
        let list: LinkedList<Int> = [1, 2]
        
        XCTAssertEqual(list.count, 2)
        XCTAssertEqual(list.first!, 1)
        XCTAssertEqual(list.last!, 2)
    }
    
    func testListWithThreeElements() {
        let list = LinkedList<Int>([1,2,3])
        
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list.first!, 1)
        XCTAssertEqual(list.last!, 3)
    }
    
    func testPeek() {
        let list: LinkedList<Int> = [1,2,3,4]
        
        XCTAssertEqual(list.peek(at: 0), 1)
        XCTAssertEqual(list.peek(at: 1), 2)
        XCTAssertEqual(list.peek(at: 2), 3)
        XCTAssertEqual(list.peek(at: 3), 4)
    }
    
    func testPrepend() {
        let list = LinkedList<Int>()
        list.prepend(1)
        list.prepend(2)
        list.prepend(3)
        
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list.first!, 3)
        XCTAssertEqual(list.last!, 1)
    }
    
    func testAppend() {
        let list = LinkedList<Int>()
        list.append(1)
        list.append(2)
        list.append(3)
        
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list.first!, 1)
        XCTAssertEqual(list.last!, 3)
    }
    
    func testInsert() {
        let list: LinkedList<Int> = [1,2,3,4]
        list.insert(-1, at: 0)
        list.insert(5, at: 5)
        list.insert(0, at: 1)
        
        XCTAssertEqual(list.count, 7)
        XCTAssertEqual(list.first!, -1)
        XCTAssertEqual(list.peek(at: 1), 0)
        XCTAssertEqual(list.peek(at: 2), 1)
        XCTAssertEqual(list.peek(at: 5), 4)
        XCTAssertEqual(list.last!, 5)
    }
    
    func testInsertToEmptyList() {
        let list = LinkedList<Int>()
        list.insert(1, at: 0)
        
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first!, 1)
        XCTAssertEqual(list.last!, 1)
        
    }
    
    func testRemoveFirst() {
        let list: LinkedList<Int> = [2,3,0,1]
        
        let value = list.removeFirst()
        
        XCTAssertEqual(value, 2)
        XCTAssertEqual(list.count, 3)
    }
    
    func testRemoveLast() {
        let list: LinkedList<Int> = [2,3,0,1]
        
        let value = list.removeLast()
        
        XCTAssertEqual(value, 1)
        XCTAssertEqual(list.count, 3)
    }
    
    func testRemoveFromOneElementList() {
        let list = LinkedList<Int>()
        list.append(1)
        
        let value = list.remove(at: 0)
        
        XCTAssertEqual(value, 1)
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
    }
    
    func testRemoveAtIndex() {
        let list: LinkedList<Int> = [2,3,0,1]
        
        let value = list.remove(at: 2)
        
        XCTAssertEqual(value, 0)
        XCTAssertEqual(list.count, 3)
    }
    
    func testRemoveAll() {
        let list: LinkedList<Int> = [2,3,0,1]
        list.removeAll()
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
    }
    
    func testReverseLinkedList() {
        let list: LinkedList<Int> = [1,2,3,4]
        
        let oldFirst = list.first!
        let oldLast = list.last!
        let count = list.count
        
        list.reverse()
        
        XCTAssertEqual(count, list.count)
        XCTAssertEqual(oldLast, list.first!)
        XCTAssertEqual(oldFirst, list.last!)
        XCTAssertEqual(list.peek(at: 1), 3)
        XCTAssertEqual(list.peek(at: 2), 2)
    }
    
    func testConformanceToSequenceProtocol() {
        let list: LinkedList<Int> = [1, 2, 3]
        
        let it = list.makeIterator()
        
        XCTAssertEqual(it.next()!, 1)
        XCTAssertEqual(it.next()!, 2)
        XCTAssertEqual(it.next()!, 3)
        XCTAssertEqual(it.next(), nil)
    }
    
    func testStringDescription() {
        let list: LinkedList<Int> = [1, 2, 3]
        let expected = "{ 1 <=> 2 <=> 3 }"
        
        let actual = String(describing: list)
        
        XCTAssertEqual(actual, expected)
    }
    
    func testMap() {
        let list: LinkedList<Int> = [1, 2, 3]
        let squares = list.map { $0*$0 }
        let expected: LinkedList<Int> = [1, 4, 9]
        
        XCTAssertEqual(squares, expected)
    }
    
    func testFilter() {
        let list = LinkedList(0..<10)
        let evens = list.filter { $0 % 2 == 0 }
        let expected: LinkedList<Int> = [0, 2, 4, 6, 8]
        
        XCTAssertEqual(evens, expected)
    }
    
}
