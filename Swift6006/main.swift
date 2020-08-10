//
//  main.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 8.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

let sizes = Array(stride(from: 0, to: 100, by: 10)) +
    Array(stride(from: 100, to: 1000, by: 100))
let numberRange = 0..<100
func makeRandomArray(size: Int) -> [Int] {
    return (0..<size).map { i in Int.random(in: numberRange) }
}

var array = [1,1,1]
array.sort(by: <)
assert(array.isSorted())


//array.remove(at: 4)
array.popLast()

