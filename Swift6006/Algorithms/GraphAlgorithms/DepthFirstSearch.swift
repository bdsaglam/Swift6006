//
//  DepthFirstSearch.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


struct GraphEdge<Vertex: Hashable> {
    var u: Vertex
    var v: Vertex
    var label: GraphEdgeLabel
}

extension GraphEdge: CustomStringConvertible where Vertex: CustomStringConvertible {
    var description: String {
        "\(String(describing: u)) -> \(String(describing: v)) | \(label)"
    }
}

enum GraphEdgeLabel: String {
    case tree
    case backward
    case forward
    case cross
}

class DepthFirstSearch<G: GraphType> {
    typealias Vertex = G.Vertex
    let graph: G
    
    var topologicalOrder: [Vertex] {
        return order.reversed()
    }
    
    private(set) var order: [Vertex]
    private(set) var classifiedEdges: [GraphEdge<Vertex>]
    private(set) var parentShipMap: [Vertex: Vertex]
    
    private var timestamp: Int
    private var startTimes: [Vertex: Int]
    private var endTimes: [Vertex: Int]
    
    init(graph: G) {
        self.graph = graph
        order = []
        parentShipMap = [:]
        classifiedEdges = []
        timestamp = 0
        startTimes = [:]
        endTimes = [:]
    }
    
    func search() {
        for vertex in graph.vertices() {
            search(startFrom: vertex)
        }
    }
    
    func search(startFrom vertex: Vertex) {
        if parentShipMap[vertex] == nil {
            visit(vertex: vertex, predecessor: vertex)
        }
    }
    
    private func visit(vertex: Vertex, predecessor: Vertex) {
        if let p = parentShipMap[vertex] { // already visited
            var label: GraphEdgeLabel
            if endTimes[vertex] == nil {
                label = .backward
            } else if startTimes[predecessor]! < startTimes[vertex]! {
                label = .forward
            } else if p == vertex {
                label = .tree
                parentShipMap[vertex] = predecessor
            } else {
                label = .cross
            }
            classifiedEdges.append(GraphEdge(u: predecessor, v: vertex, label: label))
            return
        } // visited before
        
        parentShipMap[vertex] = predecessor
        if vertex != predecessor { // not itself
            classifiedEdges.append(GraphEdge(u: predecessor, v: vertex, label: .tree))
        }
        timestamp += 1
        startTimes[vertex] = timestamp
        for n in graph.neighbors(of: vertex) {
            visit(vertex: n, predecessor: vertex)
        }
        timestamp += 1
        endTimes[vertex] = timestamp
        order.append(vertex)
    }
}

extension DepthFirstSearch {
    var isGraphCyclic: Bool {
        classifiedEdges.contains { $0.label == .backward }
    }
}

extension GraphType {
    func dfs() -> DepthFirstSearch<Self> {
        let dfs = DepthFirstSearch(graph: self)
        dfs.search()
        return dfs
    }
}
