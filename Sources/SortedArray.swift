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
    
    public typealias SubSequence = SortedArraySlice<Element>
    internal var content: [Element]
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
            
            return SortedArraySlice(base: self, range: range)
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
        var i = indices
        
        while !i.isEmpty {
            let mid = i.mid
            let _$0 = self[mid]
            
            if _$0 == element {
                if insertion {
                    return nil
                }
                else {
                    return mid
                }
            }
                
            else if cmp(_$0, element) {
                i = i.lowerBound..<mid
            }
            else {
                i = (mid + 1)..<i.upperBound
            }
        }
        if insertion {
            return i.lowerBound
        }
        else {
            return nil
        }
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
    private static func cmp(_ a: Element, _ b: Element) -> Bool {
        return a < b
    }
    
    internal let cmp : Cmp
}

