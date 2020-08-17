//
//  Recitation15.swift
//  Algorithms
//
//  Created by Barış Deniz Sağlam on 21.03.2020.
//  Copyright © 2020 Barış Deniz Sağlam. All rights reserved.
//

import Foundation


func tedJoeTravelProblem() {
    typealias Vertex = String
    typealias State = String
    typealias TransformedVertex = String
    
    let compose = { (v: Vertex, s: State) -> TransformedVertex in v + "-" + s }
    let decompose = { (v: TransformedVertex) -> Vertex in
        String(v.split(separator: "-")[0])
    }
    
    let stateTransition = [
        "odd": "even",
        "even": "odd"
    ]
    
    let g = UndirectedGraph<Vertex>()
    g.addEdge(u: "a", v: "b")
    g.addEdge(u: "a", v: "c")
    g.addEdge(u: "b", v: "c")
    g.addEdge(u: "b", v: "e")
    g.addEdge(u: "b", v: "d")
    g.addEdge(u: "c", v: "d")
    g.addEdge(u: "e", v: "d")

    
    let tg = Graph<TransformedVertex>()
    for (u, edges) in g.adjacencyMap {
        for v in edges {
            for (s, p) in stateTransition {
                tg.addEdge(u: compose(u, s), v: compose(v, p))
            }
        }
    }
    
    print("Original graph, V: \(g.vertices().count), E: \(g.adjacencyMap.values.map {$0.count}.sum())")
    print("Transformed graph, V: \(tg.vertices().count), E: \(tg.adjacencyMap.values.map {$0.count}.sum())")
    
    let startVertex = "a"
    let startState = "even"
    
    let endVertex = "e"
    let endState = "odd"
    
    let gs = tg.breadFirstSearch(start: compose(startVertex, startState))
    let transformedPath = gs.path(to: compose(endVertex, endState))
    let path = transformedPath?.map { decompose($0) }
    
    print(transformedPath)
    print(path)
}

func tedJoeWeightedTravelProblem(){
    typealias Vertex = String
    typealias State = String
    typealias TransformedVertex = String

    let compose = { (v: Vertex, s: State) -> TransformedVertex in v + "-" + s }
    let decompose = { (v: TransformedVertex) -> Vertex in
        String(v.split(separator: "-")[0])
    }

    let stateTransition = [
        "odd": "even",
        "even": "odd"
    ]

    let g = UndirectedWeightedGraph<Vertex>()
    g.addEdge(u: "a", v: "b", weight: 4)
    g.addEdge(u: "a", v: "c", weight: 2)
    g.addEdge(u: "b", v: "c", weight: 1)
    g.addEdge(u: "b", v: "e", weight: 5)
    g.addEdge(u: "b", v: "d", weight: 3)
    g.addEdge(u: "c", v: "d", weight: 2)
    g.addEdge(u: "e", v: "d", weight: 2)

    let tg = UndirectedWeightedGraph<TransformedVertex>()
    for (u, edgeMap) in g.adjacencyMap {
        for (v, w) in edgeMap {
            for (s, p) in stateTransition {
                tg.addEdge(u: compose(u, s), v: compose(v, p), weight: w)
            }
        }
    }

    print("Original graph, V: \(g.vertices().count), E: \(g.adjacencyMap.values.map {$0.count}.sum())")
    print("Transformed graph, V: \(tg.vertices().count), E: \(tg.adjacencyMap.values.map {$0.count}.sum())")

    let startVertex = "a"
    let startState = "even"

    let endVertex = "e"
    let endState = "odd"

    let transformedPath = tg.shortestPathBFS(from: compose(startVertex, startState), to: compose(endVertex, endState), keyGenerator: { (u, v, i) -> String in "\(u)-\(v)-\(i)" })
    let path = transformedPath?.map { decompose($0) }

    print(transformedPath)
    print(path)
}
