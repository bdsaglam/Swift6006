//
//  CollectionExtensions.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 8.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Element: Hashable {
    func countElements() -> [Element: Int] {
        var freqMap: [Element: Int] = [:]
        for element in self {
            let value = freqMap[element] ?? 0
            freqMap.updateValue(value + 1, forKey: element)
        }
        return freqMap
    }
}

extension Collection where Element: Numeric {
    func sum() -> Element {
        return reduce(Element(exactly: 0)!, +)
    }
}

extension Collection where Element==Int {
    func average() -> Double {
        guard count > 0 else { return Double.nan }

        return Double(sum()) / Double(count)
    }
}

extension Collection where Element==Double {
    func average() -> Double {
        guard count > 0 else { return Double.nan }

        return sum() / Double(count)
    }
}
