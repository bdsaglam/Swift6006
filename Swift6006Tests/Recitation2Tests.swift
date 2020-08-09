//
//  Recitation2Tests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 9.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006

class ExtractWordTest: XCTestCase {
    
    func testEmptyString() {
        let s = ""
        let expected: [String] = []
        let actual = extractWords(from: s)
        XCTAssertEqual(expected, actual)
    }
    
    func testSingleLine() {
        let s = "Created by Barış Deniz Sağlam on 9.08.2020.\n"
        let expected = ["created", "by", "barış", "deniz", "sağlam", "on"]
        let actual = extractWords(from: s)
        XCTAssertEqual(expected, actual)
    }
    
    func testParagraph() {
        let s = """
        Mama, take this badge off of me
        I can't use it anymore
        """
        let expected = [
            "mama", "take", "this", "badge", "off", "of", "me",
            "i", "cant", "use", "it", "anymore"
        ]
        let actual = extractWords(from: s)
        XCTAssertEqual(expected, actual)
    }
    

}
