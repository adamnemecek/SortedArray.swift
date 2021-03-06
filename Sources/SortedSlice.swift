//
//  SortedSlice.swift
//  SortedCollection
//
//  Created by Adam Nemecek on 4/29/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

public struct SortedSlice<Element : Comparable> : MutableCollection, Equatable, RandomAccessCollection,
RangeReplaceableCollection, CustomStringConvertible, ExpressibleByArrayLiteral {
    
    public typealias Base = SortedArray<Element>
    public typealias Index = Base.Index
    
    public private(set) var startIndex : Index
    public private(set) var endIndex : Index
    
    private(set) internal var base : Base
    
    public init() {
        self = []
    }

    public init(arrayLiteral literal: Element...) {
        base = SortedArray(literal)
        startIndex = base.startIndex
        endIndex = base.endIndex
    }
    
    internal init(base: Base, range: CountableRange<Index>) {
        self.base = base
        startIndex = range.lowerBound
        endIndex = range.upperBound
    }
    
    internal init(base: Base, range: Range<Index>) {
        self.base = base
        startIndex = range.lowerBound
        endIndex = range.upperBound
    }

    public var description: String {
        return base.content[indices].description
    }
    
    public func index(after i: Index) -> Index {
        return base.index(after: i)
    }
    
    public func index(before i: Index) -> Index {
        return base.index(before: i)
    }
    
    public subscript(index: Index) -> Element {
        get {
            return base[index]
        }
        set {
            base[index] = newValue
        }
    }
    
    public func sort() {
        return
    }
    
    public func sorted() -> [Element] {
        return Array(self)
    }

    public static func ==(lhs: SortedSlice, rhs: SortedSlice) -> Bool {
        return lhs.count == rhs.count && lhs.elementsEqual(rhs)
    }
    
    mutating
    public func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        base.replaceSubrange(subrange, with: [])
        
        newElements.forEach {
            base.append($0)
        }
        
        let i = indices.clamped(to: base.indices)
        startIndex = i.lowerBound
        endIndex = i.upperBound
    }
}

