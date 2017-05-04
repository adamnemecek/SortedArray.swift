//
//  SortedArray.swift
//  RangeDB
//
//  Created by Adam Nemecek on 4/29/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

extension Collection {
    var match: (head: Iterator.Element, tail: SubSequence)? {
        return first.map {
            ($0, dropFirst())
        }
    }
}



struct SortedArray<Element : Comparable> : MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral, RangeReplaceableCollection, Equatable, CustomStringConvertible, CustomDebugStringConvertible {
    typealias Index = Int
    
    typealias SubSequence = SortedArraySlice<Element>
    internal var content: [Element]
    typealias Cmp = ((Element, Element)) -> Bool
    
    init<S: Sequence>(_ sequence: S, cmp: @escaping Cmp) where S.Iterator.Element == Element {
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
    
    init() {
        self = []
    }
    
    public init<S : Sequence >(_ sequence: S) where S.Iterator.Element == Element {
        self.init(sequence, cmp: SortedArray.cmp)
    }
    
    init(arrayLiteral literal: Element...) {
        self.init(literal)
    }
    
    var startIndex: Index {
        return content.startIndex
    }
    
    var endIndex: Index {
        return content.endIndex
    }
    
    subscript(index: Index) -> Element {
        get {
            return content[index]
        }
        set {
            guard newValue != self[index] else { return }
            content.remove(at: index)
            insert(newValue)
        }
    }
    
    func sorted() -> [Element] {
        return content
    }
    
    func sort() {
        return
    }
    
    var isEmpty : Bool {
        return content.isEmpty
    }
    
    func contains(_ element: Element) -> Bool {
        return index(of: element) != nil
    }
    
    subscript(range: Range<Index>) -> SubSequence {
        get {
            
            return SortedArraySlice(base: self, range: range)
        }
        set {
            //            content[range] = newValue
            fatalError()
        }
    }
    
    func index(after i: Index) -> Index {
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
    
    func index(of element: Element, insertion: Bool = false) -> Index? {
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
    
    func index(of element: Element) -> Index? {
        return index(of: element, insertion: false)
    }
    
    func index(before i: Index) -> Index {
        return i + 1
    }
    
    func min() -> Element? {
        return first
    }
    
    func max() -> Element? {
        return last
    }
    
    static func ==(lhs: SortedArray, rhs: SortedArray) -> Bool {
        return lhs.content == rhs.content
    }
    
    
    var description: String {
        return content.description
    }
    
    var debugDescription: String {
        return content.debugDescription
    }
    
    @discardableResult
    mutating
    func uniquelyInsert(newElement: Element) -> Index? {
        return index(of: newElement, insertion: true).map {
            self.content.insert(newElement, at: $0)
            return $0
        }
    }
    
    mutating func append(_ newElement: Element) {
        uniquelyInsert(newElement: newElement)
    }
    
    mutating func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        content.replaceSubrange(subrange, with: newElements)
        content.sort(by: cmp)
    }
    
    
    func formIndex(after i: inout Int) {
        i += 1
    }
    
    
    
    @inline(__always)
    private static func cmp(_ a: Element, _ b: Element) -> Bool {
        return a < b
    }
    
    internal let cmp : Cmp
    
    
}


//extension SortedArray where Element : TimeRanged {
//
//    func index(where predicate: (Element) throws -> Element.Stride) rethrows -> Index? {
//        var i = indices
//        var candidate : Index? = nil
//
//        while !i.isEmpty {
//            let mid = i.mid
//            let _$0 = self[mid]
//            let res = predicate(_$0)
//
//
//
//            if try! predicate(_$0) {
//                candidate = mid
//            }
//            else {
//
//            }
//
//            if _$0 == element {
//                return mid
//            }
//            else if cmp(_$0, element) {
//                i = i.lowerBound..<mid
//            }
//            else {
//                i = mid..<i.upperBound
//            }
//        }
//        return nil
//    }
//
//}


