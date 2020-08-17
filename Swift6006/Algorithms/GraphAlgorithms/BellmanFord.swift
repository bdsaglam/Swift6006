//
//  BellmanFord.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


extension WeightedGraph {
    func exploreBellmanFord(from source: Vertex)
        -> WeightedGraphSearch<Vertex, Weight>
    {
        var distanceMap: [Vertex: Weight] = [:]
        var parentshipMap: [Vertex: Vertex] = [:]
        let vs = vertices()
        for vertex in vs {
            distanceMap[vertex] = Weight.max
        }
        
        distanceMap[source] = 0
        
        for _ in 1 ..< vs.count {
            // relax edges
            for (u, vw) in adjacencyMap {
                for (v, w) in vw {
                    let du = distanceMap[u]!
                    guard du != Weight.max else { continue }
                    
                    let duv = du + w
                    if duv < distanceMap[v]! {
                        distanceMap[v] = duv
                        parentshipMap[v] = u
                    }
                }
            }
        }
        
        for (u, vw) in adjacencyMap {
            // check whether the vertex is removed from parentship
            // due to negative cycle
            guard parentshipMap[u] != nil || u == source else { continue }
            
            let du = distanceMap[u]!
            guard du != Weight.max else { continue }
            
            for (v, w) in vw {
                let duv = du + w
                if duv < distanceMap[v]! {
                    // remove all vertices in negative cycle from parentshipMap
                    var current = u
                    while current != v {
                        guard let parent = parentshipMap[current] else { break }
                        parentshipMap[current] = nil
                        current = parent
                    }
                    parentshipMap[v] = nil
                }
            }
        }
        
        return WeightedGraphSearch(
            source: source,
            parentshipMap: parentshipMap,
            distanceMap: distanceMap
        )
    }
    
}


extension WeightedGraph {
    // O(kE + V)
    func kLengthShortestPathBellmanFord(from source: Vertex, k: Int)
        -> WeightedGraphSearch<Vertex, Weight>
    {
        precondition(k > 0)
        
        var distanceMap: [Vertex: Weight] = [:]
        var parentshipMap: [Vertex: Vertex] = [:]
        let vs = vertices()
        for vertex in vs {
            distanceMap[vertex] = Weight.max
        }
        
        distanceMap[source] = 0
        
        // relax edges k times
        for _ in 1 ... k {
            // postpone distance and parent updates
            // otherwise, cannot enforce k
            var distanceUpdates: [Vertex: Weight] = [:]
            var parentUpdates: [Vertex: Vertex] = [:]
            for (u, vw) in adjacencyMap {
                for (v, w) in vw {
                    let du = distanceMap[u]!
                    guard du != Weight.max else { continue }
                    
                    let duv = du + w
                    if duv < distanceMap[v]! {
                        distanceUpdates[v] = duv
                        parentUpdates[v] = u
                    }
                }
            }
            for (v, d) in distanceUpdates {
                distanceMap[v] = d
            }
            for (v, p) in parentUpdates {
                parentshipMap[v] = p
            }
        }
        
        for (u, vw) in adjacencyMap {
            // check whether the vertex is removed from parentship
            // due to negative cycle
            guard parentshipMap[u] != nil || u == source else { continue }
            
            let du = distanceMap[u]!
            guard du != Weight.max else { continue }
            
            for (v, w) in vw {
                let duv = du + w
                if duv < distanceMap[v]! {
                    // remove all vertices in negative cycle from parentshipMap
                    var current = u
                    while current != v {
                        guard let parent = parentshipMap[current] else { break }
                        parentshipMap[current] = nil
                        current = parent
                    }
                    parentshipMap[v] = nil
                }
            }
        }
        
        return WeightedGraphSearch(
            source: source,
            parentshipMap: parentshipMap,
            distanceMap: distanceMap
        )
    }
}
