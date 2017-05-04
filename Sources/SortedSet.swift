//
//  SortedSet.swift
//  SortedCollections
//
//  Created by Adam Nemecek on 4/29/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

public struct SortedSet<Element : Comparable> : MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral, RangeReplaceableCollection, Equatable, CustomStringConvertible, CustomDebugStringConvertible {
    
    public typealias Index = SortedArray<Element>.Index
    public typealias SubSequence = SortedSlice<Element>

    internal var content: SortedArray<Element>
    
    internal init<S: Sequence>(_ sequence: S, cmp: @escaping SortedArray<Element>.Cmp) where S.Iterator.Element == Element {
        let arr = sequence.sorted(by: cmp)
        
        
        
        /// we could call `contains` as we go through, but this is linear time
        
        let aa: [Element] = arr.match.map { fst in
            var prev = fst.head
            
            return [prev] + fst.tail.flatMap { e in
                defer {
                    prev = e
                }
                return e != prev ? e : nil
            }
            } ?? []
        content = SortedArray(sorted: aa, cmp: cmp)
    }
    
    public init() {
        self = []
    }
    
    public init<S : Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        self.init(sequence, cmp: SortedArray.cmp)
    }
    
    public init(arrayLiteral literal: Element...) {
        self.init(literal)
    }
    
    public var startIndex: Index {
        return content.startIndex
    }
    
    public var endIndex: Index {
        return content.endIndex
    }
    
    public subscript(index: Index) -> Element {
        get {
            return content[index]
        }
        set {
            let c = self[index]
            guard c != newValue, !contains(newValue) else { return }
            content[index] = newValue
        }
    }
    
    public func sorted() -> [Element] {
        return content.sorted()
    }
    
    public func sort() {
        return
    }
    
    public var isEmpty : Bool {
        return content.isEmpty
    }
    
    public func contains(_ element: Element) -> Bool {
        return content.contains(element)
    }
    
    public subscript(range: Range<Index>) -> SubSequence {
        get {
            return content[range]
        }
        set {
            content[range] = newValue
        }
    }
    
    public func index(after i: Index) -> Index {
        return content.index(after: i)
    }
    
    public func index(of element: Element, insertion: Bool = false) -> Index? {
        return content.index(of: element, insertion: insertion)
    }
    
    public func index(of element: Element) -> Index? {
        return index(of: element, insertion: false)
    }
    
    public func index(before i: Index) -> Index {
        return content.index(before: i)
    }
    
    public func min() -> Element? {
        return content.min()
    }
    
    public func max() -> Element? {
        return content.max()
    }
    
    public static func ==(lhs: SortedSet, rhs: SortedSet) -> Bool {
        return lhs.content == rhs.content
    }
    
    public var description: String {
        return content.description
    }
    
    public var debugDescription: String {
        return content.debugDescription
    }
    
    
    public mutating func append(_ newElement: Element) {
        guard !contains(newElement) else { return }
        append(newElement)
    }
    
    public mutating func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        content.replaceSubrange(subrange, with: [])
        content.append(contentsOf: newElements)
    }
    
    
    
}

