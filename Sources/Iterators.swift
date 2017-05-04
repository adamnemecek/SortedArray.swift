//
//  Iterators.swift
//  SortedArray
//
//  Created by Adam Nemecek on 5/4/17.
//
//

import Foundation

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

public typealias Cmp<Element: Comparable> = (Element, Element) -> Bool

struct UnionIterator<S: Sequence> : IteratorProtocol where S.Iterator.Element : Comparable {
    typealias Element = S.Iterator.Element
    private var i: MergeIterator<S>
    
    private(set) var current : Element?
    
    init(a: S, b: S, cmp: @escaping Cmp<Element>) {
        i = MergeIterator(a: a, b: b, cmp: cmp)
        current = i.next()
    }
    
    mutating
    func next() -> S.Iterator.Element? {
        while let n = i.next() {
            if n != current {
                current = n
                return current
            }
        }
        return nil
    }
}

struct SubtractingIterator<S: Sequence> : IteratorProtocol where S.Iterator.Element : Comparable {
    
    typealias Element = S.Iterator.Element
    
    var a, b: CachingIterator<S>
    var cmp: (Element, Element) -> Bool
    
    init(a: S, b: S, cmp: @escaping (Element, Element) -> Bool) {
        self.a = CachingIterator(a)
        self.b = CachingIterator(b)
        self.cmp = cmp
    }
    
    private(set) var current : Element?
    
    mutating
    func next() -> Element? {
        while let ca = a.next() {
            if let cb = b.next(), ca != cb {
                current = ca
                break
            }
            
        }
        return current
    }
}

