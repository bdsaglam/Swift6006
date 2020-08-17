//
//  MedianMaintaining.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


/**
 Maintain median
 
 It provides constant time median lookup, with O(lg(n)) insertion and removal
*/

struct MedianMaintainer {
    private(set) var median: Int
    
    private var s = AVLTree<Int, Int>()
    private var t = AVLTree<Int, Int>()
    
    init(_ array: [Int]){
        let sortedArray = array.sorted()
        median = sortedArray[array.count/2]
        for element in sortedArray[0 ..< array.count/2] {
            s.insert(key: element, value: element)
        }
        for element in sortedArray[(array.count/2 + 1) ..< array.count] {
            t.insert(key: element, value: element)
        }
    }

    mutating func insert(_ element: Int) {
        if element <= median {
            s.insert(key: element, value: element)
        } else {
            t.insert(key: element, value: element)
        }
        maintain()
    }

    mutating func remove(_ element: Int) {
        guard s.count > 0 && t.count > 0 else { return }
        
        if element == median {
            let (newMedian, _) = t.removeMin()!
            median = newMedian
        } else if element < median {
            s.remove(key: element)!
        } else {
            t.remove(key: element)!
        }
        maintain()
    }

    private mutating func maintain() {
        if s.count == t.count || s.count == t.count + 1 { return }

        if s.count < t.count {
            s.insert(key: median, value: median)
            let (newMedian, _) = t.removeMin()!
            median = newMedian
            maintain()
        } else {
            t.insert(key: median, value: median)
            let (newMedian, _) = s.removeMax()!
            median = newMedian
            maintain()
        }
    }

    func checkRepInvariance() -> Bool {
        let left = Array(s.traverseInOrder()).map { $0.0 }
        let right = Array(t.traverseInOrder()).map { $0.0 }

        let sortedArray = left + [median] + right
        guard sortedArray.isSorted() else { return false }
        
        return median == sortedArray[sortedArray.count / 2]
    }
}
