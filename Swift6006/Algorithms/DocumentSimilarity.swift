//
//  Recitation2.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 9.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


/// Split text into words.
/// - Parameter text: A String-like object
/// - Returns: array of words
func splitIntoWords<S: StringProtocol>(_ text: S, ignoreNumbers: Bool = false)
    -> [String] {
    var words:[String] = []
    var word = ""
    for c in text {
        if c.isWhitespace {
            if !word.isEmpty {
                words.append(word)
            }
            word = ""
        } else if c.isLetter || (!ignoreNumbers && c.isNumber) {
            word.append(c.lowercased())
        }
    }
    if !word.isEmpty {
        words.append(word)
    }
    return words
}

/// Calculates inner product of two dictionaries whose values are integers.
/// - Parameters:
///   - first: a dictionary with integer values
///   - second: a dictionary with integer values
/// - Returns: a scalar
func innerProduct<K: Hashable>(_ first: [K: Int], _ second: [K: Int])
    -> Double {
    var result: Double = 0
    for (k, v) in first {
        result += Double(v * second[k, default: 0])
    }
    return result
}

/// Calculates cosine similarity of two dictionaries  whose values are integers.
/// cosine_similarity( u, v ) = u · v / ( |u| * |v| )
/// - Parameters:
///   - first: a dictionary with integer values
///   - second: a dictionary with integer values
/// - Returns: a scalar in range [-1.0, 1.0]
func cosineSimilarity<K: Hashable>(_ first: [K: Int], _ second: [K: Int])
    -> Double {
    let numerator = innerProduct(first, second)
    let firstLength = sqrt(first.values.map { Double($0*$0) }.sum())
    let secondLength = sqrt(second.values.map { Double($0*$0) }.sum())
    let denumerator = firstLength * secondLength
    return max(-1.0, min(1.0, numerator / denumerator))
}

/// Calculates similarity of two texts based on word counts.
/// - Parameters:
///   - first: A String-like object
///   - second: A String-like object
/// - Returns: similarity score ranging from [0.0, 1.0]
func documentSimilarity<S: StringProtocol>(_ first: S, _ second: S) -> Double {
    let firstFreqs = splitIntoWords(first).countElements()
    let secondFreqs = splitIntoWords(second).countElements()
    return cosineSimilarity(firstFreqs, secondFreqs)
}
