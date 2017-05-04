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


struct UnionIterator<S: Sequence> : IteratorProtocol where S.Iterator.Element : Comparable {
    
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
        switch (a.current, b.current) {
        case let (.some(l), .some(r)):
            if l == r {
                _ = a.next()
                _ = b.next()
                current = l
                return l
            }
            else if cmp(l, r) {
                _ = a.next()
                current = l
                return l
            }
            
            _ = b.next()
            current = r
            return r
            
        case let (.some(l), nil):
            _ = a.next()
            current = l
            return l
            
        case let (nil, .some(r)):
            _ = b.next()
            current = r
            return r

        case (nil, nil):
            current = nil
            return nil
        }
    }
}

public typealias Cmp<Element: Comparable> = (Element, Element) -> Bool

//struct UnionIterator<S: Sequence> : IteratorProtocol where S.Iterator.Element : Comparable {
//    typealias Element = S.Iterator.Element
//    private var i: MergeIterator<S>
//    
//    private(set) var current : Element?
//    
//    private var cmp : Cmp<Element>
//    
//    init(a: S, b: S, cmp: @escaping Cmp<Element>) {
//        i = MergeIterator(a: a, b: b, cmp: cmp)
//        current = i.next()
//        self.cmp = cmp
//    }
//    
//    mutating
//    func next() -> S.Iterator.Element? {
//        while let n = i.next() {
//            if n != current {
//                current = n
//                return current
//            }
//        }
//        return nil
//    }
//    
//    mutating
//    func next1() -> Element? {
//        
//        switch (a.current, b.current) {
//        case let (.some(l), .some(r)):
//            if l == r {
//                _ = a.next()
//                _ = b.next()
//                current = l
//                return l
//            }
//            else if cmp(l, r) {
//                _ = a.next()
//                current = l
//                return l
//            }
//            _ = b.next()
//            current = r
//            return r
//            
//        case let (.some(l), nil):
//            _ = a.next()
//            current = l
//            return l
//            
//        case let (nil, .some(r)):
//            _ = b.next()
//            current = r
//            return r
//        case (nil, nil):
//            return nil
//        }
//    }
//}

struct SubtractionIterator<S: Sequence> : IteratorProtocol where S.Iterator.Element : Comparable {
    
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
            if let cb = b.current {
                
                current = ca
                break
            }
            current = ca
            
        }
        return current
    }
}

struct IntersectionIterator<S: Sequence> : IteratorProtocol where S.Iterator.Element : Comparable {
    
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
        
        switch (a.current, b.current) {
        case let (.some(l), .some(r)):
            if l == r {
                _ = a.next()
                _ = b.next()
                current = l
                return l
            }
            else if cmp(l, r) {
                _ = a.next()
                current = l
                return l
            }
            _ = b.next()
            current = r
            return r
            
        case let (.some(l), nil):
            _ = a.next()
            current = l
            return l
            
        case let (nil, .some(r)):
            _ = b.next()
            current = r
            return r
        case (nil, nil):
            return nil
        }
    }
}

struct SymmetricDifferenceIterator<S: Sequence> : IteratorProtocol where S.Iterator.Element : Comparable {
    
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
            if let cb = b.next(), ca == cb {
                current = ca
                break
            }
            
        }
        return current
    }
}
