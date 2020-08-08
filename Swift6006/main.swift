//
//  main.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 8.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


let data: [[Double]] = [
    [2.0, 1.0, 0.0],
    [-9.0, 3.0, -1.0]
]
let arr = Array2D(data)


print(arr[0])
print(arr[1])

print(arr[nil, 0])
print(arr[nil, 1])
print(arr[nil, 2])

print(arr[nil, 1].argmax()!)

print(arr.ncol)


findA2DPeakSlow(arr)
