//
//  BreadthFirstSearchTests.swift
//  Swift6006Tests
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import XCTest
@testable import Swift6006


class BreadthFirstSearchTests: XCTestCase {


    func testExample() throws {
        let wg = WeightedGraph<String>()
        wg.addEdge(u: "ankara", v: "eskisehir", weight: 1)
        wg.addEdge(u: "ankara", v: "sivas", weight: 3)
        wg.addEdge(u: "eskisehir", v: "izmir", weight: 6)
        wg.addEdge(u: "istanbul", v: "izmir", weight: 5)
        wg.addEdge(u: "ankara", v: "istanbul", weight: 4)
        wg.addEdge(u: "ankara", v: "konya", weight: 3)
        wg.addEdge(u: "konya", v: "adana", weight: 3)
        wg.addEdge(u: "adana", v: "hatay", weight: 2)
        wg.addEdge(u: "izmir", v: "hatay", weight: 17)

        print("Number of vertices: ", wg.vertices().count)
        print("Number of edges: ", wg.adjacencyMap.values.map { $0.count }.sum())

        let uwg = wg.makeUnweightedBySplittingEdges{ (u, v, i) -> String in
            "\(u)-\(v)-\(i)"
        }
        print("Number of vertices: ", uwg.vertices().count)
        print("Number of edges: ", uwg.adjacencyMap.values.map { $0.count }.sum())
        
        let gs = uwg.breadFirstSearch(start: "ankara")
        let path = gs.path(to: "izmir")!
        print(path)
        print(path.count - 1)
        print(path.filter { wg.vertices().contains($0) } )

        print(wg.vertices())
    }

    

}
