//
//  GraphType.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


// MARK: Protocol for unweighted graph

protocol GraphType:class {
    associatedtype Vertex: Hashable
    
    func neighbors(of vertex: Vertex) -> Set<Vertex>
    
    func vertices() -> Set<Vertex>
}


// MARK: Implementation of unweighted graph

class Graph<Vertex: Hashable> {
    private(set) var adjacencyMap: [Vertex: Set<Vertex>]
    
    init(adjacencyMap: [Vertex: Set<Vertex>] = [:]) {
        self.adjacencyMap = adjacencyMap
    }
    
    func addEdge(u: Vertex, v: Vertex) {
        var edges = adjacencyMap[u] ?? []
        edges.insert(v)
        adjacencyMap[u] = edges
    }
    
    func removeEdge(u: Vertex, v: Vertex) {
        if var edges = adjacencyMap[u] {
            edges.remove(v)
            adjacencyMap[u] = edges
        }
    }
    
}

extension Graph: GraphType {
    func neighbors(of vertex: Vertex) -> Set<Vertex> {
        return adjacencyMap[vertex] ?? []
    }
    
    func vertices() -> Set<Vertex> {
        return Set(adjacencyMap.keys).union(adjacencyMap.values.flatMap { $0 })
    }
}

extension Graph {
    func transposed() -> Graph<Vertex> {
        let t = Graph()
        for v in vertices() {
            for u in neighbors(of: v) {
                t.addEdge(u: u, v: v)
            }
        }
        return t
    }
}

class UndirectedGraph<Vertex: Hashable>: Graph<Vertex> {
    override func addEdge(u: Vertex, v: Vertex) {
        super.addEdge(u: u, v: v)
        super.addEdge(u: v, v: u)
    }
    
    override func removeEdge(u: Vertex, v: Vertex) {
        super.removeEdge(u: u, v: v)
        super.removeEdge(u: v, v: u)
    }
}
