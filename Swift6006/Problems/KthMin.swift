//
//  KthMin.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 17.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation


/// Finds kth minimum element in min heap
/// /// Time complexity: O(k*lg(n))
/// - Parameters:
///   - heap: Min array-heap
///   - k: index of element in sorted order, between 0 and heap.count
/// - Returns: kth minimum element
func kthMinSlow(of heap: ArrayHeap<Int>, k: Int) -> Int {
    precondition(k >= 0)
    precondition(k < heap.count)
    
    var heap = heap
    for _ in 0 ..< k {
        let _ = heap.pop()!
    }
    return heap.pop()!
}

/// Finds kth minimum element in min heap
/// Time complexity: O(k*lg(k))
/// - Parameters:
///   - heap: Min array-heap
///   - k: index of element in sorted order, between 0 and heap.count
/// - Returns: kth minimum element
func kthMin(of heap: ArrayHeap<Int>, k: Int) -> Int {
    precondition(k >= 0)
    precondition(k < heap.count)
    
    var auxHeap = ArrayHeap<(Int, Int)> { $0.1 < $1.1 }
    auxHeap.insert((0, heap.array[0]))
    for _ in 0 ..< k {
        let (index, _) = auxHeap.pop()!
        
        let leftChildIndex = heap.indexSystem.indexOfLeftChild(for: index)
        if leftChildIndex < heap.count {
            let leftChild = heap.array[leftChildIndex]
            auxHeap.insert((leftChildIndex, leftChild))
        }
        
        let rightChildIndex = heap.indexSystem.indexOfRightChild(for: index)
        if rightChildIndex < heap.count {
            let rightChild = heap.array[rightChildIndex]
            auxHeap.insert((rightChildIndex, rightChild))
        }
    }
    let (_, element) = auxHeap.pop()!
    return element
}
