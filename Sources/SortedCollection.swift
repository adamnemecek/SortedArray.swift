//
//  SortedCollection.swift
//  SortedArray
//
//  Created by Adam Nemecek on 5/4/17.
//
//

import Foundation

protocol SortedCollection1 : Collection {
    
}

extension Range {
    
}


extension SortedCollection1 where Iterator.Element : Equatable {
    func makeUniqueIterator() -> AnyIterator<Iterator.Element> {
        
//        var i = startIndex
        
        var i = makeIterator()
        var seen = 0
//        var last : Iterator.Element? = nil
        
        return AnyIterator {
            let current = i.next()
            
            defer {
                seen += 1
            }
            return current
//            guard i < self.endIndex else { return nil }
//            
//            defer {
//                i = (self.index(after: i)..<self.endIndex).first { self[$0] != last }
//            }
//            
//            return last
        }
    }
    
}

protocol SortedCollection : Collection {
    func sort()
    func sorted() -> [Iterator.Element]
    
    func index(of element: Iterator.Element)
    func index(of: Iterator.Element, insertion: Bool) -> Index?
}


