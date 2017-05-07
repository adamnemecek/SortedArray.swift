//
//  Extension.swift
//  RangeDB
//
//  Created by Adam Nemecek on 4/29/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

public typealias Predicate<Element> = (Element) -> Bool
public typealias Relation<Element> = (Element, Element) -> Bool

extension CountableRange {
    var mid : Bound {
        return lowerBound.advanced(by: count / 2)
    }
}

extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        @inline(__always)
        get {
            guard (startIndex..<endIndex).contains(index) else { return nil }
            return self[index]
        }
    }
    
    subscript(after i: Index) -> Iterator.Element? {
        return self[safe: index(after: i)]
    }
}

extension BidirectionalCollection {
    subscript(before i: Index) -> Iterator.Element? {
        return self[safe: index(before: i)]
    }
    
    var lastIndex: Index {
        return index(before: endIndex)
    }
}

extension BidirectionalCollection {
    
    func lastIndex(where: (Iterator.Element) -> Bool) -> Index? {
        return sequence(first: lastIndex) {
            /// note that the last generated element is still startIndex
            guard $0 > self.startIndex else { return nil }
            return self.index(before: $0)
        }.first { `where`(self[$0]) }
    }
}

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

internal extension Collection {
    var match: (head: Iterator.Element, tail: SubSequence)? {
        return first.map { ($0, dropFirst()) }
    }
}

extension Sequence {
    func all(predicate: Predicate<Iterator.Element>) -> Bool {
        return !contains { !predicate($0) }
    }
}


