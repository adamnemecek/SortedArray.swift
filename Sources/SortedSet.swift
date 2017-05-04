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
    
    public typealias Cmp = ((Element, Element)) -> Bool
    
    internal init<S: Sequence>(_ sequence: S, cmp: @escaping Cmp) where S.Iterator.Element == Element {
        let arr = sequence.sorted(by: cmp)
        
        self.cmp = cmp
        
        /// we could call `contains` as we go through, but this is linear time
        
        self.content = arr.match.map { fst in
            var prev = fst.head
            
            return [prev] + fst.tail.flatMap { e in
                defer {
                    prev = e
                }
                return e != prev ? e : nil
            }
            } ?? []
        
        
    }
    
    public init() {
        self = []
    }
    
    public init<S : Sequence >(_ sequence: S) where S.Iterator.Element == Element {
        self.init(sequence, cmp: SortedSet.cmp)
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
            guard content.contains(self[index]) else { return }

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
            
            return SortedSlice(base: content, range: range)
        }
        set {
            //            content[range] = newValue
            fatalError()
        }
    }
    
    public func index(after i: Index) -> Index {
        return i + 1
    }
    
    //    extension Array {
    //        func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
    //            var lo = 0
    //            var hi = self.count - 1
    //            while lo <= hi {
    //                let mid = (lo + hi)/2
    //                if isOrderedBefore(self[mid], elem) {
    //                    lo = mid + 1
    //                } else if isOrderedBefore(elem, self[mid]) {
    //                    hi = mid - 1
    //                } else {
    //                    return mid // found at position mid
    //                }
    //            }
    //            return lo // not found, would be inserted at position lo
    //        }
    //    }
    
    public func index(of element: Element, insertion: Bool = false) -> Index? {
        return content.index(of: element, insertion: insertion)
    }
    
    public func index(of element: Element) -> Index? {
        return index(of: element, insertion: false)
    }
    
    public func index(before i: Index) -> Index {
        return i + 1
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
        fatalError()
        content.sort(by: cmp)
    }
    
    
    
}

