//
//  Knapsack.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 4.04.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


protocol KnapsackItemType {
    var cost: Int { get }
    var value: Int { get }
}

/**
 for original knapsack problem, value of unused capacity is zero.
 for cash problems, value of unused capacity is itself.
 */
class Knapsack<Item: KnapsackItemType>{
    private typealias Result = (value: Int, quantity: Int)
    
    private let items: [(Item, Int)]
    private let capacity: Int
    private let valueOfUnusedCapacity: (Int) -> Int
    
    private var dp:[Int: [Int: Result]]
    
    init(items: [(Item, Int)], capacity: Int, valueOfUnusedCapacity: @escaping (Int) -> Int) {
        self.items = items
        self.capacity = capacity
        self.valueOfUnusedCapacity = valueOfUnusedCapacity
        
        dp = [:]
    }
    
    func fit() -> [Item] {
        computeDP()
        
        let n = items.count
        var includedItems: [Item] = []
        var c = capacity
        var i = 0
        while true {
            if i >= n { break }
            let (_, quantity) = dp[c]![i]!
            let item = items[i].0
            for _ in 0 ..< quantity {
                includedItems.append(item)
                c -= item.cost
            }
            
            i += 1
        }
        
        return includedItems
    }
        
    private func computeDP() {
        /*
         Recursion formula: include item i,  with quantity q
         dp[capacityLeft][i] = max {
                 dp[capacityLeft - q * cost_i][i + 1] + q * value_i
                 for each q possible
         }
         */
        let n = items.count
        for i in (0 ..< n).reversed() {
            let (item, limit) = items[i]
            for capacityLeft in 0 ... capacity {
                let maxQ = min(limit, capacityLeft / item.cost)
                let choices: [Result] = (0 ... maxQ).map { q in
                    let (value, _) = lookup(capacityLeft: capacityLeft - q * item.cost, itemIndex: i + 1)
                    return (value + q * item.value, q)
                }
                update(capacityLeft: capacityLeft,
                       itemIndex: i,
                       result: choices.max { $0.value < $1.value }!
                )
            }
        }
    }
    
    private func lookup(capacityLeft: Int, itemIndex: Int) -> Result {
        guard capacityLeft >= 0 else {
            return (Int.min, 0)
        }
        guard itemIndex < items.count else { // base case
            return (valueOfUnusedCapacity(capacityLeft), 0)
        }
        return dp[capacityLeft]![itemIndex]!
    }
    
    private func update(capacityLeft: Int, itemIndex: Int, result: Result) {
        if dp[capacityLeft] == nil {
            dp[capacityLeft] = [:]
        }
        dp[capacityLeft]![itemIndex] = result
    }
}

struct KnapsackItem: KnapsackItemType {
    var id: String
    var cost: Int
    var value: Int
}


func testKnapsack() {
    let items: [(KnapsackItem, Int)] = [
        (KnapsackItem(id: "A", cost: 10, value: 10), 3),
        (KnapsackItem(id: "B", cost: 5, value: 10),3),
        (KnapsackItem(id: "C", cost: 20, value: 15),10),
        (KnapsackItem(id: "D", cost: 2, value: 1), Int.max)
    ]
    let capacity = 24

    // unused capacity has no value
    let ks = Knapsack(items: items, capacity: capacity) { c in 0 }
    let includedItems = ks.fit()
    let cost = includedItems.map { $0.cost }.sum()
    let value = includedItems.map { $0.value }.sum()
    let totalValue = capacity - cost + value
    
    print(includedItems)
    print("initial value: \(capacity)")
    print("cost: \(cost)")
    print("value gained: \(value)")
    print("total value: \(totalValue)")

}


func testStockPurchase(interestFactor: Int) {
    let items: [(KnapsackItem, Int)] = [
        (KnapsackItem(id: "A", cost: 10000, value: 9000), 3),
        (KnapsackItem(id: "B", cost: 15000, value: 10000), 3),
        (KnapsackItem(id: "C", cost: 5000, value: 6000), 2),
        (KnapsackItem(id: "D", cost: 1000, value: 1000), 3),
    ]
    let capacity = 24000
    
    let ks = Knapsack(items: items, capacity: capacity) { c in c * interestFactor }
    let includedItems = ks.fit()
    let cost = includedItems.map { $0.cost }.sum()
    let value = includedItems.map { $0.value }.sum()
    let totalValue = capacity - cost + value

    print(includedItems)
    print("initial value: \(capacity)")
    print("cost: \(cost)")
    print("value gained: \(value)")
    print("total value: \(totalValue)")

}


func testDifferentStockMarkets() {
    print("==================================================")
    print("Negative interest rate")
    print("==================================================")
    testStockPurchase(interestFactor: 0)

    print("==================================================")
    print("Zero interest rate")
    print("==================================================")
    testStockPurchase(interestFactor: 1)

    print("==================================================")
    print("High interest rate")
    print("==================================================")
    testStockPurchase(interestFactor: 2)
}
