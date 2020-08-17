//
//  WeightedGraph.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


// MARK: Protocol

protocol WeightedGraphType {
    associatedtype Vertex: Hashable
    typealias Weight = Int
    
    func neighbors(of vertex: Vertex) -> Set<Vertex>
    
    func vertices() -> Set<Vertex>
    
    func weightOfEdge(u: Vertex, v: Vertex) -> Weight
}

extension WeightedGraphType {
    func containsEdge(from u: Vertex, to v: Vertex) -> Bool {
        return neighbors(of: u).contains(v)
    }
}


// MARK: Implementation

class WeightedGraph<Vertex: Hashable> {
    typealias Weight = Int
    private(set) var adjacencyMap: [Vertex: [Vertex: Weight]]
    
    init(adjacencyMap: [Vertex: [Vertex: Weight]] = [:]) {
        self.adjacencyMap = adjacencyMap
    }
    
    func addEdge(u: Vertex, v: Vertex, weight: Weight) {
        var vw = adjacencyMap[u] ?? [:]
        vw[v] = weight
        adjacencyMap[u] = vw
    }
    
    func removeEdge(u: Vertex, v: Vertex) {
        var vw = adjacencyMap[u]!
        vw[v] = nil
        adjacencyMap[u] = vw
    }
}

extension WeightedGraph: WeightedGraphType {
    func neighbors(of vertex: Vertex) -> Set<Vertex> {
        guard let vw = adjacencyMap[vertex] else { return [] }
        return Set(vw.keys)
    }
    
    func vertices() -> Set<Vertex> {
        return Set(adjacencyMap.keys).union(adjacencyMap.values.flatMap { $0.keys })
    }
    
    func weightOfEdge(u: Vertex, v: Vertex) -> Weight {
        let vw = adjacencyMap[u]!
        let weight = vw[v]!
        return weight
    }
}

extension WeightedGraph {
    func transposed() -> WeightedGraph<Vertex> {
        let t = WeightedGraph()
        for v in vertices() {
            for u in neighbors(of: v) {
                let w = weightOfEdge(u: v, v: u)
                t.addEdge(u: u, v: v, weight: w)
            }
        }
        return t
    }
}

extension WeightedGraph {
    func weightOfPath(path: [Vertex]) -> Weight {
        precondition(path.count > 1)
                
        let wp = zip(path[0 ..< path.count - 1], path[1 ..< path.count])
            .map { (u, v) -> Weight in
                weightOfEdge(u: u, v: v)
            }
            .sum()
        return wp
    }
}

extension WeightedGraph {
    func disregardWeights() -> Graph<Vertex> {
        let newAdjMap = Dictionary(uniqueKeysWithValues: adjacencyMap.map {
            (vertex, edgeMap) -> (Vertex, Set<Vertex>) in
            return (vertex, Set(edgeMap.keys))
        })
        
        return Graph(adjacencyMap: newAdjMap)
    }
}

class UndirectedWeightedGraph<Vertex: Hashable>: WeightedGraph<Vertex> {
    override func addEdge(u: Vertex, v: Vertex, weight: Weight) {
        super.addEdge(u: u, v: v, weight: weight)
        super.addEdge(u: v, v: u, weight: weight)
    }
    
    override func removeEdge(u: Vertex, v: Vertex) {
        super.removeEdge(u: u, v: v)
        super.removeEdge(u: v, v: u)
    }
}
