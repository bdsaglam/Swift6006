//
//  Array2DTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 8.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006

class Array2DTests: XCTestCase {
    func testEmpty() throws {
        let x = Array2D<Int>()
        XCTAssertEqual(0, x.shape.0)
        XCTAssertEqual(0, x.shape.1)
    }
    
    func testEmptyFrom1D() throws {
        let x = Array2D<Int>(data: [], shape: (0, 0))
        XCTAssertEqual(0, x.shape.0)
        XCTAssertEqual(0, x.shape.1)
    }
    
    func testEmpty2D() throws {
        let x = Array2D<Int>([[Int]]())
        XCTAssertEqual(0, x.shape.0)
        XCTAssertEqual(0, x.shape.1)
    }
    
    func testInitValid1D() throws {
        let data = Array(0..<12)
        let shape = (3,4)
        
        let x = Array2D(data: data, shape: shape)
        XCTAssertEqual(shape.0, x.nrow)
        XCTAssertEqual(shape.1, x.ncol)
    }
    
    func testInitValid2D() throws {
        let data: [[Double]] = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0]
        ]
        
        let x = Array2D(data)
        XCTAssertEqual(data.count, x.nrow)
        XCTAssertEqual(data[0].count, x.ncol)
    }
    
    func testSingleElementIndexing() throws {
        let data = Array(0..<12)
        let shape = (3,4)
        
        let arr = Array2D(data: data, shape: shape)
        XCTAssertEqual(arr[1,3], 7)
    }
    
    func testTranspose() throws {
        let data: [[Double]] = [
            [2.0, 1.0, 0.0],
            [-9.0, 3.0, -1.0],
        ]
        let dataTranspose = [
            [2.0, -9.0],
            [1.0, 3.0],
            [0.0, -1.0],
        ]
        let arr = Array2D(data)
        let arrT = arr.transpose()
        XCTAssertEqual(dataTranspose, arrT.viewAsMultiArray().map {Array($0)})
    }
    
    func testSlicingAlongDimension() throws {
        let data: [[Double]] = [
            [2.0, 1.0, 0.0],
            [-9.0, 3.0, -1.0],
        ]
        let arr = Array2D(data)
        let arrT = arr.transpose()
        
        XCTAssertEqual(arr[0, nil], data[0])
        XCTAssertEqual(arr[1, nil], data[1])
        
        XCTAssertEqual(arr[nil, 0], arrT[0, nil])
        XCTAssertEqual(arr[nil, 1], arrT[1, nil])
        XCTAssertEqual(arr[nil, 2], arrT[2, nil])
    }
    
    
    func testArgmax() throws {
        let data: [[Double]] = [
            [2.0, 1.0, 0.0],
            [-9.0, 3.0, -1.0]
        ]
        let arr = Array2D(data)
        let (r, c) = arr.argmax()!
        
        XCTAssertEqual(r, 1)
        XCTAssertEqual(c, 1)
    }
    
    func testArgmin() throws {
        let data: [[Double]] = [
            [2.0, 1.0, 0.0],
            [-9.0, 3.0, -1.0]
        ]
        let arr = Array2D(data)
        let (r, c) = arr.argmin()!
        
        XCTAssertEqual(r, 1)
        XCTAssertEqual(c, 0)
    }
    
    
    
    
    
    


}
