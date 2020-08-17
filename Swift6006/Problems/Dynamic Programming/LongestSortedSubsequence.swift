//
//  LongestSortedSubsequence.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 29.03.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


func longestSortedSubsequence(_ array: [Int]) -> [Int] {
    guard array.count > 0 else { return [] }
    
    typealias Index = Int
    var dp: [(Int, Index)] = array.indices.map { (1, $0)}
    let n = array.count
    for i in (0 ..< n - 1).reversed() {
        for j in (i + 1 ..< n) {
            if array[j] < array[i] { continue }
            
            let m = dp[j].0
            if m + 1 > dp[i].0 {
                dp[i] = (m + 1, j)
            }
        }
    }
    
    let maxIndex = dp.argmax { $0.0 < $1.0 }!
    
    var indices = [Int]()
    var i = maxIndex
    while true {
        indices.append(i)
        let successor = dp[i].1
        if successor == i { break }
        i = successor
    }
    
    return indices.map { array[$0] }
}


func testLongestSortedSubsequence() {
    assert(longestSortedSubsequence([0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15])
        .elementsEqual([0, 4, 6, 9, 13, 15])
    )
    assert(longestSortedSubsequence([0,0,0]).elementsEqual([0,0,0]))
    assert(longestSortedSubsequence([1]).elementsEqual([1]))
    assert(longestSortedSubsequence([]).elementsEqual([]))
}
