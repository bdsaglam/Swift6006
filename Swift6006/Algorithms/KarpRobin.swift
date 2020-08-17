//
//  KarpRobin.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 16.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


fileprivate let primeNumber: Int = 65519

fileprivate extension Character {
    var asInt: Int {
        Int(unicodeScalars.first?.value ?? 0)
    }
}

fileprivate extension StringProtocol {
    var asIntArray: [Int] {
        self.map { Int($0.unicodeScalars.first?.value ?? 0) }
    }
}

func karpRobinSearch<C: Collection> (
    content: C,
    pattern: C,
    sizeOfCharacterSet: Int = 512)
    -> C.Index? where C.Element==Int
{
    guard pattern.count <= content.count else { return nil }
    
    let patternRH = RollingHash(radix: sizeOfCharacterSet, divisor: primeNumber)
    pattern.forEach { patternRH.append($0) }

    let contentRH = RollingHash(radix: sizeOfCharacterSet, divisor: primeNumber)
    for i in 0..<pattern.count {
        let idx = content.index(content.startIndex, offsetBy: i)
        contentRH.append(content[idx])
    }
    
    var windowStart = content.startIndex
    var windowEnd = content.index(content.startIndex, offsetBy: pattern.count)
    while true {
        if patternRH.hash == contentRH.hash &&
            pattern.elementsEqual(content[windowStart..<windowEnd])
        { return windowStart }
        
        if windowEnd >= content.endIndex {
            break
        }
        
        contentRH.append(content[windowEnd])
        contentRH.skipFirst()
        
        windowStart = content.index(after: windowStart)
        windowEnd = content.index(after: windowEnd)
    }
    
    return nil
}

func karpRobinSearch<S: StringProtocol> (
    content: S,
    pattern: S,
    sizeOfCharacterSet: Int = 512)
    -> S.Index?
{
    let c = content.map({ $0.asInt })
    let p = pattern.map({ $0.asInt })
    guard let index = karpRobinSearch(content: c, pattern: p) else {
        return nil
    }
    return content.index(content.startIndex, offsetBy: index)
}
