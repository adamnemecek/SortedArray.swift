//
//  main.swift
//  Cmdline
//
//  Created by Adam Nemecek on 5/6/17.
//
//

import Foundation
import SortedArray

let s = SortedSet([5,2,1,2,3,6,7,8])


let a = [1,2,3,4,5,6]

let b = [1, 2, 2, 3, 3, 5, 6]
print(b)
//var u = UnionIterator(a: a, b: b) { $0 < $1 }

//print(s.contains(1))

//while let n = u.next() {
//    print(n)
//}

//
//struct UniqueSequence<Element : Equatable> : IteratorProtocol {
//    private var i: AnyIterator<Element>
////
//    private var last : Element?
//    
//    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
//        self.i = AnyIterator(sequence.makeIterator())
//        last = i.next()
//    }
//    
//    func next() -> Element? {
//        return nil
////        while let n = i.next() {
////            
////        }
//    }
//}

let c = SortedSet(b)
//let ii = s.intersection(c)
//print(s.intersection(c))
for e in s.symmetricDifference(c) {
    print(e)
}
