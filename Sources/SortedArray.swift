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

extension Sequence {
    func all(predicate: (Iterator.Element) -> Bool) -> Bool {
        return !contains { !predicate($0) }
    }
}

//extension Sequence where Iterator.Element : Comparable, SubSequence : Sequence {
//    var isSorted: Bool {
//        return zip(dropLast(), dropFirst()).all { $0.0 < $0.1 }
//    }
//}


extension Collection where Iterator.Element : Equatable, SubSequence.Iterator.Element == Iterator.Element {
    func unique() -> [Iterator.Element] {
        /// unique, we could call `contains` as we go through, but this is linear time
        return match.map { fst in
            var prev = fst.head
            
            return [prev] + fst.tail.filter { e in
                defer {
                    prev = e
                }
                return e != prev
            }
        } ?? []
    }
}

public struct SortedArray<Element : Comparable> : MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral, RangeReplaceableCollection, Equatable, CustomStringConvertible, CustomDebugStringConvertible {
    public typealias Index = Int
    
    public typealias SubSequence = SortedSlice<Element>
    internal var content: [Element]
    public typealias Cmp = ((Element, Element)) -> Bool
    
    internal init<S: Sequence>(_ sequence: S, cmp: @escaping Cmp) where S.Iterator.Element == Element {
        self.content = sequence.sorted(by: cmp)
        self.cmp = cmp
    }
    
    public init() {
        self = []
    }
    
    internal init(sorted: [Element], cmp: @escaping Cmp) {
        assert(sorted == sorted.sorted())
        content = sorted
        self.cmp = cmp
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
            append(newValue)
        }
    }
    
    public func sorted() -> [Element] {
        return content
    }
    
    public func sort() {
        return
    }
    
//    public func count(of element: Element) -> IndexDistance {
//        let
//    }
    
    public func contains(_ element: Element) -> Bool {
        return index(of: element) != nil
    }
    
    public subscript(range: Range<Index>) -> SubSequence {
        get {
            return SortedSlice(base: self, range: range)
        }
        set {
            replaceSubrange(range, with: newValue)
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
        return i - 1
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
        return "\(content)"
    }
    
    public var debugDescription: String {
        return content.debugDescription
    }
    
    public mutating func append(_ newElement: Element) {
        let idx = index(of: newElement, insertion: true)!
        content.insert(newElement, at: idx)
    }
    
    public mutating func insert(_ newElement: Element, at i: Index) {
        append(newElement)
    }
    
    public mutating func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        content.replaceSubrange(subrange, with: newElements)
        content.sort(by: cmp)
    }
    
    public mutating func removeAll(keepingCapacity keepCapacity: Bool) {
        return content.removeAll(keepingCapacity: keepCapacity)
    }
    
    public mutating func remove(at position: Index) -> Iterator.Element {
        return content.remove(at: position)
    }
    
    public mutating func removeSubrange(_ bounds: Range<Index>) {
        content.removeSubrange(bounds)
    }
    
    public func formIndex(after i: inout Int) {
        i += 1
    }
    
    public func formIndex(before i: inout Int) {
        i -= 1
    }
    
    @inline(__always)
    internal static func cmp(_ a: Element, _ b: Element) -> Bool {
        return a < b
    }
    
    internal var cmp : Cmp
}

