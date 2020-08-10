//
//  SequenceExtensions.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 10.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

extension Sequence {
    /**
       Checks whether a sequence is sorted or not.
       According to the documentation of Swift's standard library, areInIncreasingOrder closure argument of
       sorted method of sequence type must hold some properties.
       One of them is that areInIncreasingOrder(a,a) must be false.
       From documentation,
           "areInIncreasingOrder: A predicate that returns `true`
           if its first argument should be ordered before its second argument ..."
       Swift can check equality by applying this predicate twice with arguments swapped.
       If it gives false in both case, then elements are equal.
    */
    func isSorted(by areInIncreasingOrder: (Element, Element) throws -> Bool)
        rethrows -> Bool {
        var it = makeIterator()
        guard var previous = it.next() else { return true }
        
        while let current = it.next() {
            if try !areInIncreasingOrder(previous, current) &&
                areInIncreasingOrder(current, previous) {
                return false
            }
            previous = current
        }
        return true
    }
}

extension Sequence where Element: Comparable {
    func isSorted() -> Bool {
        return isSorted(by: <)
    }
}
