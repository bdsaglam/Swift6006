//
//  TopologicalOrderExploration.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


extension WeightedGraph {
    func exploreByTopologicalOrder(from source: Vertex)
        -> WeightedGraphSearch<Vertex, Weight>
    {
        let g = self.disregardWeights()
        let dfs = g.dfs()
        precondition(!dfs.isGraphCyclic)
        
        let topologicalOrder = dfs.topologicalOrder
        
        var distanceMap: [Vertex: Weight] = [:]
        var parentshipMap: [Vertex: Vertex] = [:]
        
        for vertex in vertices() {
            distanceMap[vertex] = Weight.max
        }
        
        distanceMap[source] = 0
        
        let index = topologicalOrder.firstIndex(of: source)!
        
        for i in index ..< topologicalOrder.count {
            let u = topologicalOrder[i]
            let du = distanceMap[u]!
            
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
