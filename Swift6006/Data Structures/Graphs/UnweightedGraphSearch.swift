//
//  UnweightedGraphSearchResult.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


struct GraphSearch<Vertex: Hashable>: GraphSearchType {
    let source: Vertex
    let parentshipMap: [Vertex: Vertex]
}

extension GraphSearch: Equatable {}
