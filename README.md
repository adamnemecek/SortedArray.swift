# SortedCollection

Implementation of SortedArray and SortedSet in Swift. Very much work in progress.

```
public struct SortedArray<Element : Comparable> : MutableCollection, RandomAccessCollection, ExpressibleByArrayLiteral, RangeReplaceableCollection, Equatable, CustomStringConvertible, CustomDebugStringConvertible {
  ///...
}
```


```
let a : SortedArray =  [2,6,2,1,2,35,6,7,8,0]
print(a) // [0, 1, 2, 2, 2, 6, 6, 7, 8, 35]

```


