//
//  Dijkstra.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


extension WeightedGraph {
    func exploreDijkstra(from source: Vertex)
        -> WeightedGraphSearch<Vertex, Weight>
    {
        var distanceMap: [Vertex: Weight] = [:]
        var parentshipMap: [Vertex: Vertex] = [:]
        
        for vertex in vertices() {
            distanceMap[vertex] = Weight.max
        }
        
        distanceMap[source] = 0
        
        var pq = vertices()
        
        while !pq.isEmpty {
            let u = pq.min { (x, y) -> Bool in
                distanceMap[x]! < distanceMap[y]!
            }!
            pq.remove(u)
            let du = distanceMap[u]!
            guard du != Weight.max else { continue }
            
            // relax edges
            for v in neighbors(of: u) {
                let w = weightOfEdge(u: u, v: v)
                let duv = du + w
                if duv < distanceMap[v]! {
                    distanceMap[v] = duv
                    parentshipMap[v] = u
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
    func shortestPathDijkstra(from source: Vertex, to target: Vertex)
        -> [Vertex]?
    {
        var distanceMap: [Vertex: Weight] = [:]
        var parentshipMap: [Vertex: Vertex] = [:]
        
        let vs = vertices()
        for vertex in vs {
            distanceMap[vertex] = Weight.max
        }
        
        distanceMap[source] = 0
        
        var pq = vs
        
        while !pq.isEmpty {
            let u = pq.min { (x, y) -> Bool in
                distanceMap[x]! < distanceMap[y]!
            }!
            if u == target { break } // already found target, can stop early
            pq.remove(u)
            let du = distanceMap[u]!
            guard du != Weight.max else { continue }
            
            // relax edges
            for v in neighbors(of: u) {
                let w = weightOfEdge(u: u, v: v)
                let duv = du + w
                if duv < distanceMap[v]! {
                    distanceMap[v] = duv
                    parentshipMap[v] = u
                }
            }
        }
        let gs = WeightedGraphSearch(
            source: source,
            parentshipMap: parentshipMap,
            distanceMap: distanceMap
        )
        return gs.path(to: target)
    }
    
    
    func shortestPathBiDijkstra(from source: Vertex, to target: Vertex)
        -> [Vertex]?
    {
        var distanceMapForward: [Vertex: Weight] = [:]
        var parentshipMapForward: [Vertex: Vertex] = [:]
        
        var distanceMapBackward: [Vertex: Weight] = [:]
        var parentshipMapBackward: [Vertex: Vertex] = [:]
        
        let vs = vertices()
        for vertex in vs {
            distanceMapForward[vertex] = Weight.max
            distanceMapBackward[vertex] = Weight.max
        }
        
        distanceMapForward[source] = 0
        distanceMapBackward[target] = 0
        
        var pqForward = vs
        var pqBackward = vs
        
        let transposedWG = transposed()
        
        var forward = true
        var lastVertex: Vertex? = nil
        outerLoop: while !pqForward.isEmpty && !pqBackward.isEmpty {
            if forward {
                let u = pqForward.min { (x, y) -> Bool in
                    distanceMapForward[x]! < distanceMapForward[y]!
                }!
                if u == target { break outerLoop }
                pqForward.remove(u)
                let du = distanceMapForward[u]!
                guard du != Weight.max else { continue }
                
                if u == lastVertex { break outerLoop}
                lastVertex = u
                
                // relax edges
                for v in self.neighbors(of: u) {
                    let w = self.weightOfEdge(u: u, v: v)
                    let duv = du + w
                    if duv < distanceMapForward[v]! {
                        distanceMapForward[v] = duv
                        parentshipMapForward[v] = u
                    }
                }
            } else {
                let u = pqBackward.min { (x, y) -> Bool in
                    distanceMapBackward[x]! < distanceMapBackward[y]!
                }!
                if u == source { break outerLoop }
                pqBackward.remove(u)
                let du = distanceMapBackward[u]!
                guard du != Weight.max else { continue }
                                
                if u == lastVertex { break outerLoop}
                lastVertex = u
                
                // relax edges
                for v in transposedWG.neighbors(of: u) {
                    let w = transposedWG.weightOfEdge(u: u, v: v)
                    let duv = du + w
                    if duv < distanceMapBackward[v]! {
                        distanceMapBackward[v] = duv
                        parentshipMapBackward[v] = u
                    }
                }
            }
            
            forward = !forward
        }
        
        let intersection = distanceMapForward
            .map { (u, df) -> (Vertex, Weight) in
                guard let db = distanceMapBackward[u], df < Weight.max && db < Weight.max
                else { return (u, Weight.max) }
                return (u, df + db)
            }
            .min { $0.1 < $1.1 }
        
        guard let intersectionVertex = intersection?.0 else { return nil }
        
        let gsForward = WeightedGraphSearch(source: source, parentshipMap: parentshipMapForward, distanceMap: distanceMapForward)
        let gsBackward = WeightedGraphSearch(source: target, parentshipMap: parentshipMapBackward, distanceMap: distanceMapBackward)
        
        var pathForward = gsForward.path(to: intersectionVertex)!
        let pathBackward = gsBackward.path(to: intersectionVertex)!
        
        pathForward.append(contentsOf: pathBackward.dropLast().reversed())
        
        return pathForward
    }
}
