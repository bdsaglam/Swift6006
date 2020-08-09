//
//  Utils.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 9.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

// implemented according to this answer
// https://stackoverflow.com/a/24755958/6641096
public func measureInMilliseconds(_ block: () -> ()) -> UInt64 {
    let start = DispatchTime.now()
    block()
    let end = DispatchTime.now()

    // Difference in nano seconds (UInt64)
    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    
    // Technically could overflow for long running tests
    let timeInterval = nanoTime / 1_000_000
    return timeInterval
}
