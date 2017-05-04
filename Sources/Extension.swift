//
//  Extension.swift
//  RangeDB
//
//  Created by Adam Nemecek on 4/29/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

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
            guard $0 > self.startIndex else { return nil }
            return self.index(before: $0)
        }.first { `where`(self[$0]) }
    }
}
