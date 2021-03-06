//
//  SortedSet.swift
//  SortedCollections
//
//  Created by Adam Nemecek on 4/29/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

public struct SortedSet<Element : Comparable> : MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral, RangeReplaceableCollection, Equatable, CustomStringConvertible, CustomDebugStringConvertible {
    
    public typealias Index = SortedArray<Element>.Index
    public typealias SubSequence = SortedSlice<Element>

    fileprivate var content: SortedArray<Element>
    
    internal init<S: Sequence>(_ sequence: S, cmp: @escaping Relation<Element>) where S.Iterator.Element == Element {
        let unique: [Element] = sequence.sorted(by: cmp).unique()
        
        self.init(content: unique, cmp: cmp)
    }
    
    fileprivate init(content: [Element], cmp: @escaping Relation<Element>) {
        self.content = SortedArray(sorted: content, cmp: cmp)
    }
    
    public init() {
        self = []
    }
    
    public init<S : Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        self.init(sequence, cmp: SortedArray.cmp)
    }
    
    public init(arrayLiteral literal: Element...) {
        self.init(literal)
    }
    
    public var startIndex: Index {
        return content.startIndex
    }
    
    public var endIndex: Index {
        return content.endIndex
    }
    
    public subscript(index: Index) -> Element {
        get {
            return content[index]
        }
        set {
            let c = self[index]
            guard c != newValue, !contains(newValue) else { return }
            content[index] = newValue
        }
    }
    
    public func contains(_ element: Element) -> Bool {
        return content.contains(element)
    }
    
    public subscript(range: Range<Index>) -> SubSequence {
        get {
            return content[range]
        }
        set {
            content[range] = newValue
        }
    }
    
    public func index(after i: Index) -> Index {
        return content.index(after: i)
    }
    
    public func index(of element: Element, insertion: Bool = false) -> Index? {
        return content.index(of: element, insertion: insertion)
    }
    
    public func index(of element: Element) -> Index? {
        return index(of: element, insertion: false)
    }
    
    public func index(before i: Index) -> Index {
        return content.index(before: i)
    }
    
    public func min() -> Element? {
        return content.min()
    }
    
    public func max() -> Element? {
        return content.max()
    }
    
    public static func ==(lhs: SortedSet, rhs: SortedSet) -> Bool {
        return lhs.content == rhs.content
    }
    
    public var description: String {
        return map { "\($0)" }.joined(separator: ", ")
    }
    
    public var debugDescription: String {
        return content.description
    }
    
    public mutating func append(_ newElement: Element) {
        guard !contains(newElement) else { return }
        append(newElement)
    }
    
    public mutating func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        content.removeSubrange(subrange)
        content.append(contentsOf: newElements)
    }
    
    public func sorted() -> [Element] {
        return content.sorted()
    }
    
    public func sort() {
        return
    }
}

extension SortedSet : SetAlgebra {
    public var isEmpty : Bool {
        return content.isEmpty
    }
    
    /// Removes the elements of the set that are also in the given set and adds
    /// the members of the given set that are not already in the set.
    ///
    /// In the following example, the elements of the `employees` set that are
    /// also members of `neighbors` are removed from `employees`, while the
    /// elements of `neighbors` that are not members of `employees` are added to
    /// `employees`. In particular, the names `"Alicia"`, `"Chris"`, and
    /// `"Diana"` are removed from `employees` while the names `"Forlani"` and
    /// `"Greta"` are added.
    ///
    ///     var employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
    ///     employees.formSymmetricDifference(neighbors)
    ///     print(employees)
    ///     // Prints "["Diana", "Chris", "Forlani", "Alicia", "Greta"]"
    ///
    /// - Parameter other: A set of the same type.
    public mutating func formSymmetricDifference(_ other: SortedSet) {
        self = symmetricDifference(other)
    }

    /// Removes the elements of this set that aren't also in the given set.
    ///
    /// In the following example, the elements of the `employees` set that are
    /// not also members of the `neighbors` set are removed. In particular, the
    /// names `"Alicia"`, `"Chris"`, and `"Diana"` are removed.
    ///
    ///     var employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
    ///     employees.formIntersection(neighbors)
    ///     print(employees)
    ///     // Prints "["Bethany", "Eric"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    public mutating func formIntersection(_ other: SortedSet) {
        self = intersection(other)
    }
    
    /// Adds the elements of the given set to the set.
    ///
    /// In the following example, the elements of the `visitors` set are added to
    /// the `attendees` set:
    ///
    ///     var attendees: Set = ["Alicia", "Bethany", "Diana"]
    ///     let visitors: Set = ["Marcia", "Nathaniel"]
    ///     attendees.formUnion(visitors)
    ///     print(attendees)
    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
    ///
    /// If the set already contains one or more elements that are also in
    /// `other`, the existing members are kept.
    ///
    ///     var initialIndices = Set(0..<5)
    ///     initialIndices.formUnion([2, 3, 6, 7])
    ///     print(initialIndices)
    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    public mutating func formUnion(_ other: SortedSet) {
        /// note that this is the only method that needs a dedup
        self = union(other)
    }
    
    /// Inserts the given element into the set unconditionally.
    ///
    /// If an element equal to `newMember` is already contained in the set,
    /// `newMember` replaces the existing element. In this example, an existing
    /// element is inserted into `classDays`, a set of days of the week.
    ///
    ///     enum DayOfTheWeek: Int {
    ///         case sunday, monday, tuesday, wednesday, thursday,
    ///             friday, saturday
    ///     }
    ///
    ///     var classDays: Set<DayOfTheWeek> = [.monday, .wednesday, .friday]
    ///     print(classDays.update(with: .monday))
    ///     // Prints "Optional(.monday)"
    ///
    /// - Parameter newMember: An element to insert into the set.
    /// - Returns: For ordinary sets, an element equal to `newMember` if the set
    ///   already contained such a member; otherwise, `nil`. In some cases, the
    ///   returned element may be distinguishable from `newMember` by identity
    ///   comparison or some other means.
    ///
    ///   For sets where the set type and element type are the same, like
    ///   `OptionSet` types, this method returns any intersection between the
    ///   set and `[newMember]`, or `nil` if the intersection is empty.
    @discardableResult
    public mutating func update(with newMember: Element) -> Element? {
        return index(of: newMember).map { idx in
            defer {
                self[idx] = newMember
            }
            
            return newMember
        }
    }
    
    fileprivate var cmp : Relation<Element> {
        return content.cmp
    }
    
    public func subtracting(_ other: SortedSet) -> SortedSet {
        return SortedSet(content: filter { !other.contains($0) }, cmp: cmp)
    }
    
    //    @discardableResult
    //    public mutating func remove(_ member: Element) -> (idx: Index, element: Element)? {
    //        return index(of: member).map {
    //            ($0,content.remove(at: $0))
    //        }
    //        return nil
    //    }
    
    
    /// Removes the given element and any elements subsumed by the given element.
    ///
    /// - Parameter member: The element of the set to remove.
    /// - Returns: For ordinary sets, an element equal to `member` if `member` is
    ///   contained in the set; otherwise, `nil`. In some cases, a returned
    ///   element may be distinguishable from `newMember` by identity comparison
    ///   or some other means.
    ///
    ///   For sets where the set type and element type are the same, like
    ///   `OptionSet` types, this method returns any intersection between the set
    ///   and `[member]`, or `nil` if the intersection is empty.
    @discardableResult
    public mutating func remove(_ member: Element) -> Element? {
        return index(of: member).map {
            content.remove(at: $0)
        }
    }
    
    /// Inserts the given element in the set if it is not already present.
    ///
    /// If an element equal to `newMember` is already contained in the set, this
    /// method has no effect. In this example, a new element is inserted into
    /// `classDays`, a set of days of the week. When an existing element is
    /// inserted, the `classDays` set does not change.
    ///
    ///     enum DayOfTheWeek: Int {
    ///         case sunday, monday, tuesday, wednesday, thursday,
    ///             friday, saturday
    ///     }
    ///
    ///     var classDays: Set<DayOfTheWeek> = [.wednesday, .friday]
    ///     print(classDays.insert(.monday))
    ///     // Prints "(true, .monday)"
    ///     print(classDays)
    ///     // Prints "[.friday, .wednesday, .monday]"
    ///
    ///     print(classDays.insert(.friday))
    ///     // Prints "(false, .friday)"
    ///     print(classDays)
    ///     // Prints "[.friday, .wednesday, .monday]"
    ///
    /// - Parameter newMember: An element to insert into the set.
    /// - Returns: `(true, newMember)` if `newMember` was not contained in the
    ///   set. If an element equal to `newMember` was already contained in the
    ///   set, the method returns `(false, oldMember)`, where `oldMember` is the
    ///   element that was equal to `newMember`. In some cases, `oldMember` may
    ///   be distinguishable from `newMember` by identity comparison or some
    ///   other means.
    @discardableResult
    public mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        return index(of: newMember, insertion: true).map {
            content.insert(newMember, at: $0)
            return (true, newMember)
            } ?? (false, newMember)
        
    }
    
    @discardableResult
    public mutating func insert(uniq newMember: Element) -> Index? {
        return index(of: newMember, insertion: true).map {
            content.insert(newMember, at: $0)
            return $0
        }
    }
    
    /// Returns a new set with the elements that are either in this set or in the
    /// given set, but not in both.
    ///
    /// In the following example, the `eitherNeighborsOrEmployees` set is made up
    /// of the elements of the `employees` and `neighbors` sets that are not in
    /// both `employees` *and* `neighbors`. In particular, the names `"Bethany"`
    /// and `"Eric"` do not appear in `eitherNeighborsOrEmployees`.
    ///
    ///     let employees: Set = ["Alicia", "Bethany", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani"]
    ///     let eitherNeighborsOrEmployees = employees.symmetricDifference(neighbors)
    ///     print(eitherNeighborsOrEmployees)
    ///     // Prints "["Diana", "Forlani", "Alicia"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set.
    public func symmetricDifference(_ other: SortedSet) -> SortedSet {
        let i = intersection(other)
        /// we call the sorted thing directly because
        return SortedSet(content: union(other).filter { !i.contains($0) }, cmp: cmp)
    }
    
//    public func isSubset(of other: SortedSet) -> Bool {
//        fatalError()
//    }
//    
//    public func isDisjoint(with other: SortedSet<Element>) -> Bool {
//        
//    }
    
    /// Returns a new set with the elements that are common to both this set and
    /// the given set.
    ///
    /// In the following example, the `bothNeighborsAndEmployees` set is    made up
    /// of the elements that are in *both* the `employees` and `neighbors` sets.
    /// Elements that are in either one or the other, but not both, are left out
    /// of the result of the intersection.
    ///
    ///     let employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
    ///     let bothNeighborsAndEmployees = employees.intersection(neighbors)
    ///     print(bothNeighborsAndEmployees)
    ///     // Prints "["Bethany", "Eric"]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set.
    ///
    /// - Note: if this set and `other` contain elements that are equal but
    ///   distinguishable (e.g. via `===`), which of these elements is present
    ///   in the result is unspecified.
    public func intersection(_ other: SortedSet) -> SortedSet {
        return SortedSet(content: filter { other.contains($0) }, cmp: cmp)
    }
    
    /// Returns a new set with the elements of both this and the given set.
    ///
    /// In the following example, the `attendeesAndVisitors` set is made up
    /// of the elements of the `attendees` and `visitors` sets:
    ///
    ///     let attendees: Set = ["Alicia", "Bethany", "Diana"]
    ///     let visitors = ["Marcia", "Nathaniel"]
    ///     let attendeesAndVisitors = attendees.union(visitors)
    ///     print(attendeesAndVisitors)
    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
    ///
    /// If the set already contains one or more elements that are also in
    /// `other`, the existing members are kept.
    ///
    ///     let initialIndices = Set(0..<5)
    ///     let expandedIndices = initialIndices.union([2, 3, 6, 7])
    ///     print(expandedIndices)
    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
    ///
    /// - Parameter other: A set of the same type as the current set.
    /// - Returns: A new set with the unique elements of this set and `other`.
    ///
    /// - Note: if this set and `other` contain elements that are equal but
    ///   distinguishable (e.g. via `===`), which of these elements is present
    ///   in the result is unspecified.
    public func union(_ other: SortedSet) -> SortedSet {
        return SortedSet(content + other.content, cmp: cmp)
    }
    
    //    public func contains(_ member: Element) -> Bool {
    //        return content.contains(member)
    //    }
}

