//
//  ArrayExtensions.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 8.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

// MARK: Extremes
extension Array where Element: Comparable {
    func argmax() -> Index? {
        return indices.max(by: { self[$0] < self[$1] })
    }
    
    func argmin() -> Index? {
        return indices.min(by: { self[$0] < self[$1] })
    }
}

extension Array {
    func argmax(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows-> Index? {
        return try indices.max { (i, j) throws -> Bool in
            try areInIncreasingOrder(self[i], self[j])
        }
    }
    
    func argmin(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows-> Index? {
        return try indices.min { (i, j) throws -> Bool in
            try areInIncreasingOrder(self[i], self[j])
        }
    }
}

// MARK: Aggregation
extension Array {
    func group<Key: Hashable>(by transform: (Element) -> Key) -> [Key: [Element]]{
        return self.reduce(into: [:]) { dict, current -> () in
            let key = transform(current)
            var bucket: [Element] = dict[key] ?? []
            bucket.append(current)
            dict[key] = bucket
        }
    }
}

extension Array where Element: Hashable {
    func group() -> [Element: [Element]] {
        return self.group(by: { $0 })
    }
}
//
//extension Array where Element==Int {
//    func average() -> Double {
//        return Double(self.reduce(0, +)) / Double(count)
//    }
//}
//
//extension Array where Element==Double {
//    func average() -> Double {
//        return self.reduce(Double(0), +) / Double(count)
//    }
//}
//
//extension Array where Element==Float {
//    func average() -> Float {
//        return self.reduce(Float(0), +) / Float(count)
//    }
//}


extension Array where Element: Numeric {
    func cumsum() ->  [Element] {
        guard count > 0 else { return [] }
        var cs = self
        for i in 1..<array.count {
            cs[i] += cs[i-1]
        }
        return cs
    }
}


