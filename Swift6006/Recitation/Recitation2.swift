//
//  Recitation2.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 9.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

func extractWords<S: StringProtocol>(from s: S) -> [String] {
    var words:[String] = []
    var word = ""
    for c in s {
        if c.isWhitespace || c.isNewline {
            if !word.isEmpty {
                words.append(word)
            }
            word = ""
        } else if c.isLetter {
            word.append(c.lowercased())
        }
    }
    if !word.isEmpty {
        words.append(word)
    }
    return words
}

func wordFrequencies(_ doc: String) -> [String: Int] {
    return doc.split(whereSeparator: \.isNewline).lazy
        .map { extractWords(from: $0).countElements()}
        .reduce(into: [String:Int]()) { (dict, current) in
            dict.merge(current, uniquingKeysWith: +)
        }
}

func innerProduct<K: Hashable>(_ first: [K: Int], _ second: [K: Int]) -> Double {
    var numerator: Double = 0
    for (k, v) in first {
        numerator += Double(v * second[k, default: 0])
    }
    let firstLength = sqrt(first.values.map { Double($0*$0) }.sum())
    let secondLength = sqrt(second.values.map { Double($0*$0) }.sum())
    let denumerator = firstLength * secondLength
    return numerator / denumerator
}

func documentSimilarity(_ first: String, _ second: String) -> Double {
    let firstFreqs = wordFrequencies(first)
    let secondFreqs = wordFrequencies(second)
    return innerProduct(firstFreqs, secondFreqs)
}
