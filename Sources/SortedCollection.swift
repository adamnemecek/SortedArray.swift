//
//  SortedCollection.swift
//  SortedArray
//
//  Created by Adam Nemecek on 5/4/17.
//
//

import Foundation

protocol SortedSequence : Sequence {
    
}

protocol SortedCollection : Collection {
    func sort()
    func sorted() -> [Iterator.Element]
    
    func index(of: Iterator.Element, insertion: Bool) -> Index?
}


