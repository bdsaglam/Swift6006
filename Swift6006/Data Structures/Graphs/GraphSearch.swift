//
//  GraphSearchResultType.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


protocol GraphSearchType {
    associatedtype Vertex: Hashable
    
    var source: Vertex { get }
    
    var parentshipMap: [Vertex: Vertex] { get }
}

extension GraphSearchType {
    func path(to end: Vertex) -> [Vertex]? {
        var current = end
        var path: [Vertex] = [current]
        while current != source {
            guard let parent = parentshipMap[current] else {
                return nil
            }
            if parent == current {
                return nil
            }
            path.append(parent)
            current = parent
        }
        
        return path.reversed()
    }
}

protocol WeightedGraphSearchType: GraphSearchType {
    associatedtype Weight: Numeric
    
    func distance(to end: Vertex) -> Weight?
}
