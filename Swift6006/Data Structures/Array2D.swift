//
//  Array2D.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 8.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

struct Array2D<Element> {
    enum Dimension: Int {
        case row, column
    }
    
    private var data:[Element]
    var shape: (Int, Int)
    
    var nrow: Int { shape.0 }
    var ncol: Int { shape.1 }
    var count: Int { data.count }
    
    init() {
        self.data = []
        self.shape = (0, 0)
    }
    
    init(data: [Element], shape: (Int, Int)) {
        precondition(data.count == shape.0 * shape.1, "Invalid shape \(shape) for data with \(data.count) elements")
        self.data = data
        self.shape = shape
    }
}


extension Array2D {
    func isIndexValid(_ row: Int, _ column: Int) -> Bool {
        return 0 <= row && row < nrow && 0 <= column && column < ncol
    }
    
    func flattenIndex(_ row: Int, _ column:Int) -> Int {
        return row * ncol + column
    }
    
    func unflattenIndex(_ index: Int) -> (row: Int, column: Int) {
        let row = index / ncol
        let column = index % ncol
        return (row: row, column: column)
    }
    
    func flatIndices(of dimension:Dimension, _ index: Int) -> [Int] {
        switch dimension {
        case .row:
            return (0..<ncol).map { flattenIndex(index, $0) }
        case .column:
            return (0..<nrow).map { flattenIndex($0, index) }
        }
    }
    
    subscript(row: Int, column: Int) -> Element {
        get {
            precondition(isIndexValid(row, column), "Index out of range")
            return data[flattenIndex(row, column)]
        }
        set {
            precondition(isIndexValid(row, column), "Index out of range")
            data[flattenIndex(row, column)] = newValue
        }
    }
    
    subscript(rows: [Int], columns: [Int]) -> [Element] {
        get {
            precondition(rows.count == columns.count,
                         "Number of rows and columns must be same")
            var elements = [Element]()
            for i in 0 ..< rows.count {
                let r = rows[i]
                let c = columns[i]
                elements.append(self[r, c])
            }
            return elements
        }
        set {
            precondition(rows.count == columns.count &&
                columns.count == newValue.count,
                         "Number of rows and columns must be same"
            )
            for i in 0..<rows.count {
                let r = rows[i]
                let c = columns[i]
                self[r, c] = newValue[i]
            }
        }
    }
    
    subscript(rows:[Int]?, columns:[Int]?) -> [Element] {
        get {
            if rows==nil && columns==nil { return data }
            
            let rows = rows ?? Array(0..<nrow)
            let columns = columns ?? Array(0..<ncol)
            
            return self[rows, columns]
        }
        set {
            if rows==nil && columns==nil {
                data = newValue
            }
            
            let rows = rows ?? Array(0..<nrow)
            let columns = columns ?? Array(0..<ncol)
            
            self[rows, columns] = newValue
            
        }
    }
    
    subscript(row:Int?, column:Int? = nil) -> [Element] {
        get {
            if row==nil && column==nil { return data }
            
            var rows:[Int]
            if row==nil {
                rows = Array(0..<nrow)
            } else {
                rows = Array(repeating: row!, count: ncol)
            }
            
            var columns:[Int]
            if column==nil {
                columns = Array(0..<ncol)
            } else {
                columns = Array(repeating: column!, count: nrow)
            }
            
            return self[rows, columns]
        }
        set {
            if row==nil && column==nil {
                data = newValue
            }
            
            var rows:[Int]
            if row==nil {
                rows = Array(0..<nrow)
            } else {
                rows = Array(repeating: row!, count: nrow)
            }
            
            var columns:[Int]
            if column==nil {
                columns = Array(0..<ncol)
            } else {
                columns = Array(repeating: column!, count: ncol)
            }
            self[rows, columns] = newValue
            
        }
    }
    
}

extension Array2D where Element: Comparable {
    func argmax() -> (row: Int, column: Int)? {
        guard data.count > 0 else { return nil }
        let index = data.argmax()!
        return unflattenIndex(index)
    }
    
    func argmin() -> (row: Int, column: Int)? {
        guard data.count > 0 else { return nil }
        let index = data.argmin()!
        return unflattenIndex(index)
    }
}


extension Array2D {
    init(_ multiArray: [[Element]]) {
        let nrow = multiArray.count
        let ncol = multiArray[safe: 0]?.count ?? 0
        
        precondition((multiArray.map{ $0.count }.allSatisfy{ $0==ncol }),
                     "All rows must have same number of elements")

        self.data = multiArray.flatMap{ $0 }
        self.shape = (nrow, ncol)
    }

    func viewAsMultiArray() -> [ArraySlice<Element>] {
        var multiArray: [ArraySlice<Element>] = []
        var start = 0
        var end = ncol
        for _ in 0..<nrow {
            let row = self.data[start..<end]
            multiArray.append(row)
            start += ncol
            end += ncol
        }
        return multiArray
    }
    
    func transpose() -> Self {
        let multiArray: [[Element]] = (0..<ncol).map { self[nil, $0] }
        return Self(multiArray)
    }
}

extension Array2D: CustomStringConvertible where Element: CustomStringConvertible {
    var description: String {
        var s:String = ""
        for row in viewAsMultiArray() {
            s.append(String(describing: row))
            s.append("\n")
        }
        return s
    }
}

