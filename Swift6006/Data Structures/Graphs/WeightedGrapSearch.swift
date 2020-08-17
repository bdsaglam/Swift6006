//
//  WeightedGrapSearch.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


struct WeightedGraphSearch<Vertex: Hashable, Weight: Numeric>: WeightedGraphSearchType
{
    let source: Vertex
    let parentshipMap: [Vertex: Vertex]
    let distanceMap: [Vertex: Weight]
    
    func distance(to end: Vertex) -> Weight? {
        distanceMap[end]
    }
}

extension WeightedGraphSearch: Equatable {}
