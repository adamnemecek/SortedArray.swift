//
//  SortedCollection.swift
//  SortedArray
//
//  Created by Adam Nemecek on 5/4/17.
//
//

import Foundation

protocol SortedCollection : Collection {
    func sort()
    func sorted() -> [Iterator.Element]
    
    func index(of: Iterator.Element, insertion: Bool) -> Index?
}

protocol CachingIter : IteratorProtocol {
    var current : Element? { get }
}

struct CachingIterator<S: Sequence> : IteratorProtocol {
    typealias Element = S.Iterator.Element
    
    private(set) var current: Element?
    
    private var i: S.Iterator
    
    init(_ sequence: S) {
        i = sequence.makeIterator()
        current = i.next()
    }
    mutating func next() -> S.Iterator.Element? {
        current = i.next()
        return current
    }
}


struct MergeIterator<S: Sequence> : IteratorProtocol where S.Iterator.Element : Comparable {
    
    typealias Element = S.Iterator.Element
    
    var a, b: CachingIterator<S>
    var cmp: (Element, Element) -> Bool
    
    init(a: S, b: S, cmp: @escaping (Element, Element) -> Bool) {
        self.a = CachingIterator(a)
        self.b = CachingIterator(b)
        self.cmp = cmp
    }
    
    var current : Element? {
        guard let i = a.current, let j = b.current else { return nil }
        if cmp(i, j) {
            return i
        }
        return j
    }
    
    mutating
    func next() -> Element? {
        switch (a.current, b.current) {
        case let (.some(l), .some(r)):
            if cmp(l, r) {
                _ = a.next()
                return l
            }
            _ = b.next()
            return r
            
        case let (.some(l), nil):
            _ = a.next()
            return l
            
        case let (nil, .some(r)):
            _ = b.next()
            return r
        case (nil, nil):
            return nil
        }
    }	
}



//struct UniqueMergeIterator<S: Sequence> : IteratorProtocol where S.Iterator.Element : Comparable {
//    typealias Element = S.Iterator.Element
//    private var i: MergeIterator<S>
//    
//    private(set) var current : Element?
//    
//    init(a: S, b: S) {
//        i = MergeIterator(a: a, b: b)
//        current = i
//    }
//    
//    mutating
//    func next() -> S.Iterator.Element? {
//        
//    }
//    
//}
