//
//  KarpRobinTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 16.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006


class KarpRobinTests: XCTestCase {
    
    func testEmptyTextEmptyPattern() {
        let text = ""
        let pattern = ""
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        XCTAssertEqual(startIndex, text.startIndex)
    }
    
    func testNonEmptyTextEmptyPattern() {
        let text = "something"
        let pattern = ""
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        XCTAssertEqual(startIndex, text.startIndex)
    }
    
    func testEmptyTextNonEmptyPattern() {
        let text = ""
        let pattern = "anything"
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        XCTAssertNil(startIndex)
    }
    
    func testPatternExistsInAsciiText() {
        let text = "Rolling in the hash"
        let pattern = "the"
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        let expected = text.range(of: pattern)!.lowerBound
        XCTAssertEqual(startIndex, expected)
    }
    
    func testPatternNotExistInAsciiText() {
        let text = "Such a brilliant algorithm"
        let pattern = "much"
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        XCTAssertNil(startIndex)
    }
    
    func testPatternExistsInNonAsciiText() {
        let text = "Swift muhteşem bir programlama dili!"
        let pattern = "muhteşem"
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        let expected = text.range(of: pattern)!.lowerBound
        XCTAssertEqual(startIndex, expected)
    }
    
    func testPatternNotExistInNonAsciiText() {
        let text = #"Fakat Xcode pek de iyi bir IDE değil ¯\_(ツ)_/¯"#
        let pattern = "muhteşem"
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        XCTAssertNil(startIndex)
    }
    
    func testPatternWithSpacesNotExistText() {
        let text = "Congrats! It's a match."
        let pattern = "It s"
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        XCTAssertNil(startIndex)
    }
    
    func testPatternAtEndOfText() {
        let text = "Rolling in the hash"
        let pattern = "hash"
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        let expected = text.range(of: pattern)!.lowerBound
        XCTAssertEqual(startIndex, expected)
    }
    
    func testPatternAtBeginnningOfText() {
        let text = "Rolling in the hash"
        let pattern = "Rolling"
        let startIndex = karpRobinSearch(content: text, pattern: pattern)
        
        let expected = text.range(of: pattern)!.lowerBound
        XCTAssertEqual(startIndex, expected)
    }
    
}
