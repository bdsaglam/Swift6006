//
//  BinarySearch.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


extension Collection where Self.Element: Comparable {
    
    func binarySearch(_ target: Element) -> Index? {
        return binarySearch( target, start: startIndex, end: endIndex)
    }
    
    func binarySearch(_ target: Element, start: Index, end: Index) -> Index? {
        var start = start
        var end = end

        while start < end {
            let dist = self.distance(from: start, to: end)
            let mid = self.index(start, offsetBy: dist/2)
            let midElement = self[mid]
            
            if target == midElement {
                return mid
            }
            if target < midElement {
                end = mid
            } else {
                start = self.index(mid, offsetBy: 1)
            }
        }

        return nil
    }

}
