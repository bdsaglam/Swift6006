//
//  Lecture21.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 30.03.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


enum EditOperation {
    case insert(Int, Int)
    case delete(Int)
    case replace(Int, Int)
    case keep(Int, Int)
}

protocol EditCostModel {
    associatedtype Element: Equatable
    func cost(of operation: EditOperation, raw: [Element], target: [Element]) -> Int
}

class OptimalEditor<Element: Equatable, M: EditCostModel> where M.Element == Element {
    var totalCost: Int {
        assert(dp[0]![0]!.0 == operations().map { cost(of: $0)}.sum())
        return dp[0]![0]!.0
    }
    private var dp: [Int: [Int: (Int, EditOperation)]]
    private let raw: [Element]
    private let target: [Element]
    private let costModel: M
    
    init(raw: [Element], target: [Element], costModel: M) {
        self.raw = raw
        self.target = target
        self.costModel = costModel
        dp = [:]
        
        findFewestEditOperations()
    }
    
    func operations() -> [EditOperation] {
        var operations: [EditOperation] = []
        var i = 0
        var j = 0
        while true {
            if i == raw.count && j == target.count { break }
            let op = lookupOperation(i, j)
            operations.append(op)
            (i, j) = next(i, j, operation: op)
        }
        
        return operations
    }
    
    func transformationSteps() -> [[Element]] {
        var steps: [[Element]] = []
        
        var s: [Element] = self.raw
        var offset = 0
        for op in operations() {
            switch op {
            case .insert(let i, let j):
                s.insert(target[j], at: i+offset)
                offset += 1
            case .delete(let i):
                s.remove(at: i + offset)
                offset -= 1
            case .replace(let i, let j):
                s[i + offset] = target[j]
            case .keep:
                continue
            }
            steps.append(s)
        }
        
        return steps
    }
    
    private func findFewestEditOperations() {
        for i in raw.indices.reversed() {
            for j in target.indices.reversed() {
                let operations: [EditOperation] = [.insert(i, j), .delete(i), .replace(i, j), .keep(i, j)]
                let opCostPairs = operations.map { ($0, self.calculateTotalCost(i, j, operation: $0)) }
                let bestOpCostPair = opCostPairs.min { $0.1 < $1.1 }!
                let (bestOp, bestCost) = bestOpCostPair
                update(i, j, cost: bestCost, operation: bestOp)
            }
        }
    }
    
    private func calculateTotalCost(_ i: Int, _ j: Int, operation: EditOperation) -> Int {
        let (newI, newJ) = next(i, j, operation: operation)
        let (sum, didOverflow) = cost(of: operation)
            .addingReportingOverflow(lookupCost(newI, newJ))
        return didOverflow ? Int.max : sum
    }
    
    private func next(_ i: Int, _ j: Int, operation: EditOperation) -> (Int, Int) {
        switch operation {
        case .insert:
            return (i, j + 1)
        case .delete:
            return (i + 1, j)
        case .replace:
            return (i + 1, j + 1)
        case .keep:
            return (i + 1, j + 1)
        }
    }
    
    private func lookupCost(_ i: Int, _ j: Int) -> Int {
        // base condition
        if i == raw.count && j == target.count { return 0 }
        
        // if we reach end of raw before target, then;
        // only option is to insert all remaining characters to raw
        if i >= raw.count && j < target.count {
            return cost(of: .insert(i, j)) * (target.count - j)
        }
        
        // if we reach end of target before raw, then;
        // only option is to delete all remaining characters from raw
        if i < raw.count && j >= target.count {
            return cost(of: .delete(i)) * (raw.count - i)
        }
        
        return dp[i]![j]!.0
    }
    
    private func lookupOperation(_ i: Int, _ j: Int) -> EditOperation {
        // if we reach end of raw before target, then;
        // only option is to insert characters to raw
        if i >= raw.count && j < target.count { return .insert(i, j) }
        
        // if we reach end of target before raw, then;
        // only option is to delete characters from raw
        if i < raw.count && j >= target.count { return .delete(i) }
        
        if i == raw.count && j == target.count { fatalError() } // invalid state
        
        return dp[i]![j]!.1
    }
    
    private func update(_ i: Int, _ j: Int, cost: Int, operation: EditOperation) {
        if dp[i] == nil {
            dp[i] = [:]
        }
        dp[i]![j] = (cost, operation)
    }
    
    private func cost(of operation: EditOperation) -> Int {
        return costModel.cost(of: operation, raw: raw, target: target)
    }

}


class SimpleEditCostModel<Element: Equatable>: EditCostModel {
    func cost(of operation: EditOperation, raw: [Element], target: [Element]) -> Int {
        // we can modify this cost function to take individual elements into account
        switch operation {
        case .insert(let i, let j):
            return 10
        case .delete(let i):
            return 10
        case .replace(let i, let j):
            return 10
        case .keep(let i, let j):
            return raw[i] == target[j] ? 0 : Int.max
        }
    }
}


class AutoCorrectCostModel: EditCostModel {
    private let keyboardLayout: [Character: (Int, Int)]
    
    init() {
        var layout: [Character: (Int, Int)] = [:]
        let rows = [
            "1234567890",
            "qwertyuiop[]",
            "asdfghjkl;'",
            "`zxcvbnm,./"
        ]
        for (r, row) in rows.enumerated() {
            for (c, char) in row.enumerated() {
                layout[char] = (r, c)
            }
        }
        
        keyboardLayout = layout
        
    }
        
    func cost(of operation: EditOperation, raw: [Character], target: [Character]) -> Int {
        switch operation {
        case .insert(let i, let j):
            let c = target[j]
            if c == " " { return 5 }
            else { return 10 }
        case .delete(let i):
            if i - 1 > 0 {
                // over pressed
                if raw[i - 1] == raw[i] { return 5 }
            }
            if i + 1 < raw.count {
                // over pressed
                if raw[i + 1] == raw[i] { return 5 }
            }
            return 10
        case .replace(let i, let j):
            let chari = raw[i]
            guard let (ri, ci) = keyboardLayout[chari] else { return 10 }
            let charj = target[j]
            guard let (rj, cj) = keyboardLayout[charj] else { return 10 }
            
            // also add constant cost to encourage keeping
            return abs(rj - ri) + abs(cj - ci) + 1
        case .keep(let i, let j):
            return raw[i] == target[j] ? 0 : Int.max
        }
    }
}


func testEditDistanceDPSimple() {
    let raw = Array("aheloz,wrld ")
    let target = Array("hello world")

    print(raw)
    print(target)
    let costModel = SimpleEditCostModel<Character>()
    let editor = OptimalEditor(raw: raw, target: target, costModel: costModel)
    print("SIMPLE")
    print(editor.totalCost)
    editor.operations().forEach { print($0) }
    editor.transformationSteps().map { String($0) }.forEach{ print($0) }
}


func testAutoCorrectModelEditDistance(){
    let target = Array("hello world")
    let raw1 = Array("gellloworrd")
    let raw2 = Array("hallq,worlds")


    print(target)

    let autoCorrectModel = AutoCorrectCostModel()

    for raw in [raw1, raw2] {
        print(Array(repeating: "=", count: 40).joined())
        let editor = OptimalEditor(raw: raw, target: target, costModel: autoCorrectModel)
        print(raw)
        print(editor.totalCost)
        editor.operations().forEach {
            let cost = autoCorrectModel.cost(of: $0, raw: raw, target: target)
            print($0, cost)
        }
    }
}
