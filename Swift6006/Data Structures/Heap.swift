//
//  Heap.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 10.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

protocol Heap {
    associatedtype Element
    
    var count: Int { get }
    
    /// Returns the min/max element of heap without removing
    func peek() -> Element?
    
    /// Removes and returns the min/max element of heap
    mutating func pop() -> Element?
    
    mutating func insert(_ element: Element)
}

class ZeroBasedArrayHeapIndexSystem {
    private init() {}
    
    static let rootIndex = 0
    
    static func indexOfParent(for index:Int) -> Int{
        if index==rootIndex { return rootIndex }
        return (index - 1) / 2
    }
    
    static func indexOfLeftChild(for index:Int) -> Int{
        return 2*index + 1
    }

    static func indexOfRightChild(for index:Int) -> Int{
        return 2*index + 2
    }
}

struct ArrayHeap<Element>: Heap {
    let indexSystem = ZeroBasedArrayHeapIndexSystem.self
    let areInIncreasingOrder: (Element, Element) -> Bool
    var count: Int { array.count }
    
    private(set) var array: [Element]
    
    init(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        self.array = []
        self.areInIncreasingOrder = areInIncreasingOrder
    }
    
    mutating func insert(_ element: Element) {
        array.append(element)
        let lastIndex = array.indices.last!
        if lastIndex == indexSystem.rootIndex { return }
        
        heapifyUp(startIndex: indexSystem.indexOfParent(for: lastIndex))
    }
    
    func peek() -> Element? {
        return array[safe: indexSystem.rootIndex]
    }
    
    mutating func pop() ->  Element? {
        guard let lastIndex = array.indices.last else { // heap is empty
            return nil
        }
        
        if lastIndex == indexSystem.rootIndex {
            return array.remove(at: indexSystem.rootIndex)
        }
        
        array.swapAt(indexSystem.rootIndex, lastIndex)
        let value = array.remove(at: lastIndex)
        heapifyDown(startIndex: indexSystem.rootIndex)
        
        return value
    }
    
    // starting from a node, fixes order violations upward in the tree
    // heapify returns the child index after swap
    // therefore, to go up, we need to look at the parent of the original node
    private mutating func heapifyUp(startIndex: Int) {
        var index = startIndex
        while true {
            let newIndex = heapify(index: index)
            // stop if swap not occurred
            if newIndex == index { break }
            index = indexSystem.indexOfParent(for: index)
        }
    }
    
    // starting from a node, fix order violations downward in the tree
    private mutating func heapifyDown(startIndex: Int) {
        var index = startIndex
        while true {
            let newIndex = heapify(index: index)
            // stop if swap not occurred
            if newIndex == index { break }
            index = newIndex
        }
    }
    
    // fix an order violation if there is, for the node at index
    // check the children and promote the appropiate one if there is a violation
    // return same index if there was no violation,
    // otherwise return the new index of the original node
    private mutating func heapify(index: Int) -> Int {
        let leftIndex = indexSystem.indexOfLeftChild(for: index)
        let rightIndex = indexSystem.indexOfRightChild(for: index)

        var targetIndex:Int = index
        if leftIndex < array.count && areInOrder(leftIndex, targetIndex) {
            targetIndex = leftIndex
        }
        if rightIndex < array.count && areInOrder(rightIndex, targetIndex) {
            targetIndex = rightIndex
        }

        if index != targetIndex {
            array.swapAt(index, targetIndex)
            return targetIndex
        }
        
        return index
    }
    
    private func areInOrder(_ firstIndex: Int, _ secondIndex: Int) -> Bool {
        let first = array[firstIndex]
        let second = array[secondIndex]
        return areInIncreasingOrder(first, second) ||
            !areInIncreasingOrder(second, first)
    }
    
}

extension ArrayHeap {
    init(
           from initialArray: [Element],
           by areInIncreasingOrder: @escaping (Element, Element) -> Bool
   ) {
       self.array = initialArray
       self.areInIncreasingOrder = areInIncreasingOrder
       build()
   }
   
   private mutating func build() {
       let midIndex = array.count/2 + indexSystem.rootIndex

       for i in (indexSystem.rootIndex...midIndex).reversed() {
           heapifyDown(startIndex:i)
       }
   }
}

struct ArrayHeapIterator<Element>: IteratorProtocol {
    var arrayHeap: ArrayHeap<Element>
    
    mutating func next() -> Element? {
        return arrayHeap.pop()
    }
}

extension ArrayHeap: Sequence {
    typealias Iterator = ArrayHeapIterator<Element>
    
    func makeIterator() -> Iterator {
        return ArrayHeapIterator(arrayHeap: self)
    }
}

extension ArrayHeap where Element: Comparable {
    static func makeMaxHeap(from initialArray: [Element] = []) -> Self {
        return ArrayHeap(from: initialArray, by: >)
    }
    
    static func makeMinHeap(from initialArray: [Element] = []) -> Self {
        return ArrayHeap(from: initialArray, by: <)
    }
}
