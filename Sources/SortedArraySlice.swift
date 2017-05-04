//
//  SortedSlice.swift
//  RangeDB
//
//  Created by Adam Nemecek on 4/29/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

public struct SortedSlice<Element : Comparable> : MutableCollection, Equatable, RandomAccessCollection,
RangeReplaceableCollection, CustomStringConvertible {
    
    public typealias Base = SortedArray<Element>
    public typealias Index = Base.Index
    
    public let startIndex : Index
    public let endIndex : Index
    
    private(set) internal var base : Base
    
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
    
    public init() {
        let base = Base()
        self.init(base: Base(), range: base.indices)
    }
    
    public static func ==(lhs: SortedSlice, rhs: SortedSlice) -> Bool {
        return lhs.elementsEqual(rhs)
    }
    
    mutating
    public
    func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        base.replaceSubrange(subrange, with: newElements)
    }

}

