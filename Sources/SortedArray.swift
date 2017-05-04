//
//  SortedArray.swift
//  RangeDB
//
//  Created by Adam Nemecek on 4/29/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

internal extension Collection {
    var match: (head: Iterator.Element, tail: SubSequence)? {
        return first.map {
            ($0, dropFirst())
        }
    }
}



public struct SortedArray<Element : Comparable> : MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral, RangeReplaceableCollection, Equatable, CustomStringConvertible, CustomDebugStringConvertible {
    public typealias Index = Int
    
    public typealias SubSequence = SortedSlice<Element>
    internal var content: [Element]
    public typealias Cmp = ((Element, Element)) -> Bool
    
    internal init<S: Sequence>(_ sequence: S, cmp: @escaping Cmp) where S.Iterator.Element == Element {
        /// we could call `contains` as we go through, but this is linear time
        self.content = sequence.sorted()
        self.cmp = cmp
    }
    
    public init() {
        self = []
    }
    
    internal init(sorted: [Element], cmp: Cmp) {
        assert(sorted == sorted.sorted())
        content = sorted
        self.cmp = SortedArray.cmp
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
            guard newValue != self[index] else { return }
            content.remove(at: index)
            insert(newValue)
        }
    }
    
    public func sorted() -> [Element] {
        return content
    }
    
    public func sort() {
        return
    }
    
    public var isEmpty : Bool {
        return content.isEmpty
    }
    
    public func contains(_ element: Element) -> Bool {
        return index(of: element) != nil
    }
    
    public subscript(range: Range<Index>) -> SubSequence {
        get {
            
            return SortedSlice(base: self, range: range)
        }
        set {
            //            content[range] = newValue
            fatalError()
        }
    }
    
    public func index(after i: Index) -> Index {
        return i + 1
    }
    
    public func index(of element: Element, insertion: Bool = false) -> Index? {
        var i = indices
        
        while !i.isEmpty {
            let mid = i.mid
            let _$0 = self[mid]
            
            if _$0 == element {
                return mid
            }
                
            else if cmp(element, _$0) {
                i = i.lowerBound..<mid
            }
            else {
                i = (mid + 1)..<i.upperBound
            }
        }

        return insertion ? i.lowerBound : nil
    }
    
    public func index(of element: Element) -> Index? {
        return index(of: element, insertion: false)
    }
    
    public func index(before i: Index) -> Index {
        return i + 1
    }
    
    public func min() -> Element? {
        return first
    }
    
    public func max() -> Element? {
        return last
    }
    
    public static func ==(lhs: SortedArray, rhs: SortedArray) -> Bool {
        return lhs.content == rhs.content
    }
    
    public var description: String {
        return content.description
    }
    
    public var debugDescription: String {
        return content.debugDescription
    }
    
    @discardableResult
    mutating
    internal func uniquelyInsert(newElement: Element) -> Index? {
        return index(of: newElement, insertion: true).map {
            self.content.insert(newElement, at: $0)
            return $0
        }
    }
    
    public mutating func append(_ newElement: Element) {
        uniquelyInsert(newElement: newElement)
    }
    
    public mutating func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        content.replaceSubrange(subrange, with: newElements)
        content.sort(by: cmp)
    }
    
    
    public func formIndex(after i: inout Int) {
        i += 1
    }
    
    @inline(__always)
    internal static func cmp(_ a: Element, _ b: Element) -> Bool {
        return a < b
    }
    
    internal var cmp : Cmp
}

