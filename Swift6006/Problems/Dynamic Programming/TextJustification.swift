//
//  TextJustification.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 29.03.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


struct TextLineBreakResult {
    var words: [String]
    var lineBreaks: [Int]
}

extension TextLineBreakResult {
    func lineIntervals() -> [(Int, Int)] {
        var lineIntervals: [(Int, Int)] = []
        var start = 0
        for end in lineBreaks {
            lineIntervals.append((start, end))
            start = end
        }
        
        return lineIntervals
    }
    
    func lines() -> [[String]] {
        var lineArray: [[String]] = []
        var start = 0
        for end in lineBreaks {
            lineArray.append(Array(words[start ..< end]))
            start = end
        }
        
        return lineArray
    }
}

protocol TextLineBreakerType {
    func breakLines(words: [String]) -> TextLineBreakResult
}

protocol OptimalTextLineBreakerType: TextLineBreakerType {
    var columnWidth: Int { get }
    
    func badness(lineWidth: Int) -> Int
}

extension OptimalTextLineBreakerType {
    func breakLines(words: [String]) -> TextLineBreakResult {
        // formulate this problem with dynamic programming as
        // dp[lineStart] = min{badness(currentLine = words[lineStart ..< suffixStart]) + dp[suffixStart]
        //                     for each suffixStart possible with this lineStart}
        // we know that for any solution, the first line always starts with the first word
        // therefore; dp[0] is the optimal solution
        let n = words.count
        var dp = Array(repeating: (Int.max, (-1, -1)), count: n)
        // add one extra at the end for base condition
        dp.append((0, (-1, -1)))
        for i in (0 ..< n).reversed() {
            var bestBadness = Int.max
            var bestInterval = (-1, -1)
            for j in (i + 1 ... n) {
                let lineBadness = badness(words[i..<j])
                let suffixBadness = dp[j].0
                let (sum, didOverflow) = lineBadness.addingReportingOverflow(suffixBadness)
                let totalBadness = didOverflow ? Int.max : sum
                if totalBadness < bestBadness {
                    bestBadness = totalBadness
                    bestInterval = (i, j)
                }
            }
            dp[i] = (bestBadness, bestInterval)
        }
        
        var lineBreaks: [Int] = []
        var i = 0
        while true {
            let (_, end) = dp[i].1
            guard end < n else { break }
            lineBreaks.append(end)
            i = end
        }
        
        return TextLineBreakResult(words: words, lineBreaks: lineBreaks)
    }
    
    func badness<S: Sequence>(_ wordSequence: S) -> Int where S.Element == String {
        let width = wordSequence.map { $0.count + 1 }.sum() - 1
        return badness(lineWidth: width)
    }
}


struct PolynomialLineBreaker: OptimalTextLineBreakerType {
    var columnWidth: Int
    var exponent: Int
    
    func badness(lineWidth: Int) -> Int {
        guard lineWidth <= columnWidth else { return Int.max }
        return pow(base: columnWidth - lineWidth, exponent: exponent)
    }
    
}

extension PolynomialLineBreaker {
    static func laTeX(columnWidth: Int) -> Self {
        PolynomialLineBreaker(columnWidth: columnWidth, exponent: 3)
    }
}

func chunk(n: Int, into m: Int) -> [Int] {
    precondition(m > 0)
    var result = Array(repeating: 0, count: m)
    for i in 0 ..< n {
        let j = i % m
        result[j] = result[j] + 1
    }
    
    return result
}

struct TextAligner {
    var columnWidth: Int
    
    func justify(lineElements: [String]) -> String {
        let k = lineElements.count
        if k == 1 {
            return alignLeft(lineElements: lineElements)
        }

        let spaceCount = columnWidth - totalWidth(lineElements)
        precondition(spaceCount >= 0)
        var spaces = chunk(n: spaceCount, into: k - 1)
        spaces.append(0)
        
        var lineParts: [String] = []
        for i in 0 ..< k {
            lineParts.append(lineElements[i])
            lineParts.append(contentsOf: Array(repeating: " ", count: spaces[i]))
        }
        
        return lineParts.joined()
    }
    
    func alignLeft(lineElements: [String]) -> String {
        let realLine = lineElements.joined(separator: " ")
        let spaceCount = columnWidth - realLine.count
        precondition(spaceCount >= 0)
        if spaceCount == 0 {
            return realLine
        }
        return realLine + Array(repeating: " ", count: spaceCount).joined()
    }
    
    func alignRight(lineElements: [String]) -> String {
        let realLine = lineElements.joined(separator: " ")
        let spaceCount = columnWidth - realLine.count
        precondition(spaceCount >= 0)
        if spaceCount == 0 {
            return realLine
        }
        return Array(repeating: " ", count: spaceCount).joined() + realLine
    }
    
    func alignCenter(lineElements: [String]) -> String {
        let realLine = lineElements.joined(separator: " ")
        let spaceCount = columnWidth - realLine.count
        precondition(spaceCount >= 0)
        if spaceCount == 0 {
            return realLine
        }
        let halfSpaceCount = spaceCount / 2
        let remSpaceCount = spaceCount % 2
        let leftSpaceCount = halfSpaceCount
        let rightSpaceCount = halfSpaceCount + remSpaceCount
        return Array(repeating: " ", count: leftSpaceCount).joined()
            + realLine
            + Array(repeating: " ", count: rightSpaceCount).joined()
    }
    
    private func totalWidth(_ lineElements: [String]) -> Int {
        return lineElements.map { $0.count }.sum()
    }
    
}



func testTextJustification() {
    let text = """
    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
    """
    
    let columnWidth = 40
    let words = Array(text.split(separator: " ").map { String($0) })
    let laTeX = PolynomialLineBreaker.laTeX(columnWidth: columnWidth)

    let result = laTeX.breakLines(words: words)

    let aligner = TextAligner(columnWidth: columnWidth)

    let hr = Array(repeating: "=", count: columnWidth - 7).joined()

    print()
    print("just   " + hr)
    print()
    result.lines()
        .map { aligner.justify(lineElements: $0) }
        .forEach { print($0) }

    print()
    print("left   " + hr)
    print()
    result.lines()
        .map { aligner.alignLeft(lineElements: $0) }
        .forEach { print($0) }

    print()
    print("right  " + hr)
    print()
    result.lines()
        .map { aligner.alignRight(lineElements: $0) }
        .forEach { print($0) }

    print()
    print("center " + hr)
    print()
    result.lines()
        .map { aligner.alignCenter(lineElements: $0) }
        .forEach { print($0) }

    print()

}


func testDifferentTextJustification() {
    let text = """
    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
    """
    
    let columnWidth = 40
    let words = Array(text.split(separator: " ").map { String($0) })

    let aligner = TextAligner(columnWidth: columnWidth)
    let hr = Array(repeating: "=", count: columnWidth - 7).joined()
    
    for i in 1 ... 4 {
        print()
        print("^\(i) just" + hr)
        print()
        PolynomialLineBreaker(columnWidth: columnWidth, exponent: i)
            .breakLines(words: words)
            .lines()
            .map { aligner.justify(lineElements: $0)}
            .forEach { print($0) }
    }
    
}

