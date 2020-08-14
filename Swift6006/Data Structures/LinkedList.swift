//
//  LinkedList.swift
//  Swift6006
//
//  Created by Barış Deniz Sağlam on 12.08.2020.
//  Copyright © 2020 BDS. All rights reserved.
//

import Foundation

// MARK: Definition

final class LinkedList<Element> {
    private class Node<Element> {
        var element: Element
        var next: Node<Element>?
        weak var previous: Node<Element>?
        
        init(_ element: Element) {
            self.element = element
        }
    }
    private(set) var count: Int
    
    private var head: Node<Element>?
    private var tail: Node<Element>?
    
    init() {
        count = 0
    }
    
    var first: Element? {
        head?.element
    }
    
    var last: Element? {
        tail?.element
    }
    
    func peek(at index: Int) -> Element {
        return peekNode(at: index).element
    }
    
    private func peekNode(at index: Int) -> Node<Element> {
        guard index >= 0 && index < count else {
            fatalError("Index out of range")
        }
        
        var i = 0
        var current: Node = head!
        while i != index {
            current = current.next!
            i += 1
        }
        
        return current
    }
    
    func prepend(_ newElement: Element) {
        let node = Node(newElement)
        
        if let oldHead = head {
            node.next = oldHead
            oldHead.previous = node
        }
        
        head = node
        if tail == nil { tail = node }
        
        count += 1
    }
    
    func append(_ newElement: Element) {
        let node = Node(newElement)
        
        if let oldTail = tail {
            oldTail.next = node
            node.previous = oldTail
        }
        
        tail = node
        if head == nil { head = node }
        
        count += 1
    }
    
    
       
    func insert(_ newElement: Element, at index: Int) {
        guard index >= 0 && index <= count else {
            fatalError("Index out of range")
        }
        
        if index == 0 {
            prepend(newElement)
            return
        }
        
        if index == count {
            append(newElement)
            return
        }
        
        let node = Node(newElement)
        let nextNode = peekNode(at: index)
        let prevNode = nextNode.previous!
        prevNode.next = node
        node.previous = prevNode
        nextNode.previous = node
        node.next = nextNode
        
        count += 1
    }
    
    @discardableResult
    func removeFirst() -> Element? {
        guard let oldHead = head else {
            return nil
        }
        
        if let newHead = oldHead.next {
            oldHead.next = nil
            newHead.previous = nil
            head = newHead
        } else {
            oldHead.next = nil
            head = nil
            tail = nil
        }
        
        assert(oldHead.previous == nil)
        assert(head?.previous == nil)
        
        count -= 1
        return oldHead.element
    }
    
    @discardableResult
    func removeLast() -> Element? {
        guard let oldTail = tail else {
            return nil
        }
        
        if let newTail = oldTail.previous {
            oldTail.previous = nil
            newTail.next = nil
            tail = newTail
        } else {
            oldTail.previous = nil
            head = nil
            tail = nil
        }
        
        assert(oldTail.next == nil)
        assert(tail?.next == nil)
        
        count -= 1
        return oldTail.element
    }
    
    @discardableResult
    func remove(at index: Int) -> Element {
        guard index >= 0 && index < count else {
            fatalError("Index out of range")
        }
        if index == 0 {
            return removeFirst()!
        }
        
        if index == count - 1 {
            return removeLast()!
        }
        
        let node = peekNode(at: index)
        let nextNode = node.next!
        let prevNode = node.previous!
        prevNode.next = nextNode
        node.previous = nil
        nextNode.previous = prevNode
        node.next = nil
        
        count -= 1
        return node.element
    }
    
    func removeAll() {
        head = nil
        tail = nil
        count = 0
    }

    
    public func reverse() {
        let oldHead = head
        var next = head
        while let currentNode = next {
            next = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            // necessary to have a strong reference to node
            // otherwise, it is cleared from memory
            head = currentNode
        }
        tail = oldHead
    }
    
}

// MARK: Convenience initializers

extension LinkedList {
    convenience init<S: Sequence> (_ sequence: S)
        where S.Element == Element
    {
        self.init()
        sequence.forEach(append)
    }
}


extension LinkedList: ExpressibleByArrayLiteral {
    convenience init(arrayLiteral elements: Element...) {
        self.init()
        elements.forEach(append)
    }
}

// MARK: Conformance to Sequence protocol

extension LinkedList: Sequence {
    typealias Iterator = AnyIterator<Element>
    
    func makeIterator() -> Iterator {
        var current = head
                    
        return AnyIterator {
            guard let node = current else { return nil }
            current = node.next
            return node.element
        }
    }
}

// MARK: Conformance to CustomStringConvertible

extension LinkedList: CustomStringConvertible {
    var description: String {
        guard count > 0 else { return "{}" }
        var s: String = "{ "
        let it = makeIterator()
        for _ in 0..<count - 1 {
            s.append("\(it.next()!) <=> ")
        }
        s.append("\(it.next()!) }")
        return s
    }
}

// MARK: Implementation of map and filter
extension LinkedList {
    func map<T>(_ transform: (Element) throws -> T) rethrows -> LinkedList<T> {
        let result = LinkedList<T>()
        for element in self {
            result.append(try transform(element))
        }
        return result
    }
    
    func filter(_ isIncluded: (Element) throws -> Bool) rethrows
        -> LinkedList<Element>
    {
        let result = LinkedList<Element>()
        for element in self {
            if try isIncluded(element) { result.append(element) }
        }
        return result
    }

}

// MARK: Conformance to Equatable

extension LinkedList: Equatable where Element: Equatable {
    static func == (lhs: LinkedList<Element>, rhs: LinkedList<Element>) -> Bool {
        guard lhs.count == rhs.count else { return false }
        
        let lit = lhs.makeIterator()
        let rit = rhs.makeIterator()
        
        while let left = lit.next(), let right = rit.next() {
            if left != right { return false }
        }
        
        return true
    }
}

// MARK: Other utilities

extension LinkedList {
    var isEmpty: Bool { count == 0 }
}

extension LinkedList{
    func firstIndex(where predicate: (Element) throws -> Bool) rethrows
        -> Int?
    {
        for (i, elem) in self.enumerated() {
            if try predicate(elem) { return i }
        }
        return nil
    }
}

extension LinkedList where Element: Equatable {
    func firstIndex(of target: Element) -> Int? {
        return firstIndex { $0 == target }
    }
}

