//
//  BreadthFirstSearch.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


// MARK: Bread-first search on unweighted graphs

extension GraphType {
    func breadFirstSearch(start: Vertex) -> GraphSearch<Vertex> {
        var parentshipMap: [Vertex: Vertex] = [:]
        var levels: [Int: [Vertex]] = [:]
        var i = 0
        
        // if no parent, set itself as parent
        parentshipMap[start] = start
        levels[i] = [start]
        
        var frontier = [start]
        while !frontier.isEmpty {
            i += 1
            var next: [Vertex] = []
            for p in frontier {
                for n in neighbors(of: p) {
                    if let _ = parentshipMap[n] { // visited before
                        continue
                    }
                    parentshipMap[n] = p
                    var verticesAtLevel = levels[i] ?? []
                    verticesAtLevel.append(n)
                    levels[i] = verticesAtLevel
                    
                    next.append(n)
                }
            }
            frontier = next
        }
        
        return GraphSearch(source: start, parentshipMap: parentshipMap)
    }
}

extension GraphType {
    // BFS implementation with queue
    func breadFirstSearchWithQueue(start: Vertex) -> GraphSearch<Vertex> {
        var parentshipMap: [Vertex: Vertex] = [:]
        var levelMap: [Vertex: Int] = [:]
        var i = 0

        parentshipMap[start] = start // if no parent, it is its own parent
        levelMap[start] = 0

        let queue = LinkedList<Vertex>()
        queue.append(start)
        while !queue.isEmpty {
            i += 1
            let p = queue.removeFirst()!

            for n in neighbors(of: p) {
                if let _ = parentshipMap[n] { // visited before
                    continue
                }

                parentshipMap[n] = p
                levelMap[n] = levelMap[p]! + 1

                queue.append(n)
            }
        }
        
        var levels: [Int: [Vertex]] = [:]
        for (p, lev) in levelMap {
            levels[lev] = (levels[lev] ?? []) + [p]
        }
        
        return GraphSearch(source: start, parentshipMap: parentshipMap)
    }
}

extension UndirectedGraph {
    func bidirectionalBFS(from start: Vertex, to end: Vertex) -> [Vertex]? {
        var parentshipMapForward: [Vertex: Vertex] = [:]
        var parentshipMapBackward: [Vertex: Vertex] = [:]
        var frontierForward: Set<Vertex> = [start]
        var frontierBackward: Set<Vertex> = [end]
        
        var forward = true
        while !frontierForward.isEmpty && !frontierBackward.isEmpty {
            // if both bfs discover a vertex at the same time
            // then, shortest path passes through that vertex
            let intersection = frontierForward.intersection(frontierBackward)
            if !intersection.isEmpty {
                let c = intersection.first!
                
                let gs1 = GraphSearch(source: start, parentshipMap: parentshipMapForward)
                let gs2 = GraphSearch(source: end, parentshipMap: parentshipMapBackward)
                
                var path1 = gs1.path(to: c)!
                let path2 = gs2.path(to: c)!
                
                path1.append(contentsOf: path2.dropLast().reversed())
                
                return path1
            }
            
            if forward {
                var nextForward: Set<Vertex> = []
                for u in frontierForward {
                    for n in self.neighbors(of: u) {
                        if let _ = parentshipMapForward[n] {
                            continue
                        }
                        nextForward.insert(n)
                        parentshipMapForward[n] = u
                    }
                }
                frontierForward = nextForward
            }
            else {
                var nextBackward: Set<Vertex> = []
                for u in frontierBackward {
                    for n in self.neighbors(of: u) {
                        if let _ = parentshipMapBackward[n] {
                            continue
                        }
                        nextBackward.insert(n)
                        parentshipMapBackward[n] = u
                    }
                }
                frontierBackward = nextBackward
            }
            
            forward = !forward
        }
        
        return nil
    }
}

// MARK: Bread-first search on weigted graphs

extension WeightedGraph {
    
    func makeUnweightedBySplittingEdges(
        keyGenerator: (Vertex, Vertex, Int) -> Vertex)
        -> Graph<Vertex>
    {
        let graph = Graph<Vertex>()
        for (u, edgeMap) in adjacencyMap {
            for (v, weight) in edgeMap {
                precondition(weight > 0)
                var previous = u
                for i in 1 ..< weight {
                    let newVertex = keyGenerator(u, v, i)
                    graph.addEdge(u: previous, v: newVertex)
                    previous = newVertex
                }
                graph.addEdge(u: previous, v: v)
            }
        }
        return graph
    }
    
    func shortestPathBFS(
        from start: Vertex,
        to target: Vertex,
        keyGenerator: (Vertex, Vertex, Int) -> Vertex )
        -> [Vertex]?
    {
        let unweightedGraph = makeUnweightedBySplittingEdges(
            keyGenerator: keyGenerator)
        
        let gs = unweightedGraph.breadFirstSearch(start: start)
        let path = gs.path(to: target)
        let vs = vertices()
        return path?.filter { vs.contains($0) }
    }
}
