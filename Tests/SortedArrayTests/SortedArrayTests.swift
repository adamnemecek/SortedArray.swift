import XCTest
@testable import SortedArray

class SortedArrayTests: XCTestCase {
    func testExample() {
        let input = [6,2,1,2,8,2,1,2,4,7,9]
        
        
        let p = SortedArray(input)
        let s = input.sorted()
//        print(input.sorted())
//        print(p)
        XCTAssert(p.elementsEqual(s), "Equal")
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        XCTAssertEqual(SortedArray().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
