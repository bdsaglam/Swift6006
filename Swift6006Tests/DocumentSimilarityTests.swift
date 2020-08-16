//
//  Recitation2Tests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 9.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006


class SplitIntoWordsTest: XCTestCase {
    
    func testEmptyString() {
        let s = ""
        let expected: [String] = []
        let actual = splitIntoWords(s)
        XCTAssertEqual(expected, actual)
    }
    
    func testSingleLine() {
        let s = "Created by Barış Deniz Sağlam on 9.08.2020.\n"
        let expected = ["created", "by", "barış", "deniz", "sağlam", "on", "9082020"]
        let actual = splitIntoWords(s)
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
        let actual = splitIntoWords(s)
        XCTAssertEqual(expected, actual)
    }
    
}

class CosineSimilarityTest: XCTestCase {
    
    func testSameDictionaries() {
        let a = ["A": 1, "B": 2]
        let b = ["A": 1, "B": 2]

        XCTAssertEqual(5.0, innerProduct(a, b), accuracy: 1e-3)
        XCTAssertEqual(1.0, cosineSimilarity(a, b), accuracy: 1e-3)
    }
    
    func testOppositeDictionaries() {
        let a = ["A": 1, "B": 2]
        let b = ["A": -1, "B": -2]
        XCTAssertEqual(-5, innerProduct(a, b), accuracy: 1e-3)
        XCTAssertEqual(-1.0, cosineSimilarity(a, b), accuracy: 1e-3)
    }
    
    func testCompletelyDifferentDictionaries() {
        let a = ["A": 1, "B": 2]
        let b = ["C": -1, "D": 10]

        XCTAssertEqual(0.0, innerProduct(a, b), accuracy: 1e-3)
        XCTAssertEqual(0.0, cosineSimilarity(a, b), accuracy: 1e-3)
    }
    
}

class DocumentSimilarityTest: XCTestCase {
    func testSameText() {
        let s = """
        Swift is a new programming language for iOS, macOS, watchOS, and tvOS app development. Nonetheless, many parts of Swift will be familiar from your experience of developing in C and Objective-C.

        Swift provides its own versions of all fundamental C and Objective-C types, including Int for integers, Double and Float for floating-point values, Bool for Boolean values, and String for textual data. Swift also provides powerful versions of the three primary collection types, Array, Set, and Dictionary, as described in Collection Types.

        Like C, Swift uses variables to store and refer to values by an identifying name. Swift also makes extensive use of variables whose values can’t be changed. These are known as constants, and are much more powerful than constants in C. Constants are used throughout Swift to make code safer and clearer in intent when you work with values that don’t need to change.

        In addition to familiar types, Swift introduces advanced types not found in Objective-C, such as tuples. Tuples enable you to create and pass around groupings of values. You can use a tuple to return multiple values from a function as a single compound value.

        Swift also introduces optional types, which handle the absence of a value. Optionals say either “there is a value, and it equals x” or “there isn’t a value at all”. Using optionals is similar to using nil with pointers in Objective-C, but they work for any type, not just classes. Not only are optionals safer and more expressive than nil pointers in Objective-C, they’re at the heart of many of Swift’s most powerful features.

        Swift is a type-safe language, which means the language helps you to be clear about the types of values your code can work with. If part of your code requires a String, type safety prevents you from passing it an Int by mistake. Likewise, type safety prevents you from accidentally passing an optional String to a piece of code that requires a non-optional String. Type safety helps you catch and fix errors as early as possible in the development process.
        """
        let similarityScore = documentSimilarity(s, s)
        XCTAssertTrue(0.999 < similarityScore)
    }
    
    func testDifferentText() {
        let s = """
        Swift is a new programming language for iOS, macOS, watchOS, and tvOS app development. Nonetheless, many parts of Swift will be familiar from your experience of developing in C and Objective-C.

        Swift provides its own versions of all fundamental C and Objective-C types, including Int for integers, Double and Float for floating-point values, Bool for Boolean values, and String for textual data. Swift also provides powerful versions of the three primary collection types, Array, Set, and Dictionary, as described in Collection Types.

        Like C, Swift uses variables to store and refer to values by an identifying name. Swift also makes extensive use of variables whose values can’t be changed. These are known as constants, and are much more powerful than constants in C. Constants are used throughout Swift to make code safer and clearer in intent when you work with values that don’t need to change.

        In addition to familiar types, Swift introduces advanced types not found in Objective-C, such as tuples. Tuples enable you to create and pass around groupings of values. You can use a tuple to return multiple values from a function as a single compound value.

        Swift also introduces optional types, which handle the absence of a value. Optionals say either “there is a value, and it equals x” or “there isn’t a value at all”. Using optionals is similar to using nil with pointers in Objective-C, but they work for any type, not just classes. Not only are optionals safer and more expressive than nil pointers in Objective-C, they’re at the heart of many of Swift’s most powerful features.

        Swift is a type-safe language, which means the language helps you to be clear about the types of values your code can work with. If part of your code requires a String, type safety prevents you from passing it an Int by mistake. Likewise, type safety prevents you from accidentally passing an optional String to a piece of code that requires a non-optional String. Type safety helps you catch and fix errors as early as possible in the development process.
        """

        let s2 = """
        Swift is a fantastic way to write software, whether it’s for phones, desktops, servers, or anything else that runs code. It’s a safe, fast, and interactive programming language that combines the best in modern language thinking with wisdom from the wider Apple engineering culture and the diverse contributions from its open-source community. The compiler is optimized for performance and the language is optimized for development, without compromising on either.

        Swift is friendly to new programmers. It’s an industrial-quality programming language that’s as expressive and enjoyable as a scripting language. Writing Swift code in a playground lets you experiment with code and see the results immediately, without the overhead of building and running an app.

        Swift defines away large classes of common programming errors by adopting modern programming patterns:

        Variables are always initialized before use.
        Array indices are checked for out-of-bounds errors.
        Integers are checked for overflow.
        Optionals ensure that nil values are handled explicitly.
        Memory is managed automatically.
        Error handling allows controlled recovery from unexpected failures.
        Swift code is compiled and optimized to get the most out of modern hardware. The syntax and standard library have been designed based on the guiding principle that the obvious way to write your code should also perform the best. Its combination of safety and speed make Swift an excellent choice for everything from “Hello, world!” to an entire operating system.

        Swift combines powerful type inference and pattern matching with a modern, lightweight syntax, allowing complex ideas to be expressed in a clear and concise manner. As a result, code is not just easier to write, but easier to read and maintain as well.

        Swift has been years in the making, and it continues to evolve with new features and capabilities. Our goals for Swift are ambitious. We can’t wait to see what you create with it.
        """
        let similarityScore = documentSimilarity(s, s2)
        XCTAssertTrue(similarityScore < 1)
    }
    
}
