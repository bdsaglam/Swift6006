//
//  main.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 8.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

func makeRandomArray(size: Int) -> [Int] {
    return (0..<size).map { i in Int.random(in: 0..<100) }
}

//let array = [100, 121, 102, 113, 140, 100]
//
//print(radixSort(array, numDigits: 3, base: 10))

let array = makeRandomArray(size: 10000).map { Int($0)}
//let array = Array(repeating: 1, count: 100000)
//print(array)

print(measureInMilliseconds {
    let result = bucketSort(array, minValue: array.min()!, maxValue: array.max()!)
//    assert(result.isSorted())
})


