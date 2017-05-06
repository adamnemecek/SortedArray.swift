//
//  Diff.swift
//  SortedArray
//
//  Created by Adam Nemecek on 5/6/17.
//
//



//public struct Diff : Equatable {
//    public var deletes : Set<Int> = []
//    public var inserts : Set<Int> = []
//    public var moves : Set<Move> = []
//    
//    public struct Move : Hashable {
//        public let from: Int
//        public let to: Int
//        public var hashValue: Int {
//            return Set([from, to]).hashValue
//        }
//        
//        static public func ==(lhs: Move, rhs: Move) -> Bool {
//            return lhs.from == rhs.from && lhs.to == rhs.to
//        }
//    }
//    
//    static public func ==(lhs: Diff, rhs: Diff) -> Bool {
//        return lhs.deletes == rhs.deletes && lhs.inserts == rhs.inserts && lhs.moves == rhs.moves
//    }
//}
//
//public static func diff(_ source: SortedSet, _ target: SortedSet) -> Diff  {
//    var diff = Diff()
//    var targetSet = Set(target)
//    let targetIndices = indices(target)
//    for (index, element) in source.enumerated().reversed() {
//        if let newElement = targetSet.remove(element) {
//            if element < newElement || element > newElement {
//                diff.moves.insert(Diff.Move(from: index, to: targetIndices[element.hashValue]!))
//            }
//        } else {
//            diff.deletes.insert(index)
//        }
//    }
//    for element in targetSet {
//        guard let index = targetIndices[element.hashValue] else {
//            continue
//        }
//        diff.inserts.insert(index)
//    }
//    return diff
//}
