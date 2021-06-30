import RouterCore
import XCTest
import XCTRouter

class AnyRouteableTests: RouteableTestCase {
    
    func testErasure() {
        let representation = SomeRouteable(value: 42)

        assert(
            content: representation.eraseToAnyRouteable(),
            isDescribedAs: representation
        )
    }
    
    func testEquality() {
        let first = SomeRouteable(value: 108).eraseToAnyRouteable()
        let second = SomeRouteable(value: "Hello, World").eraseToAnyRouteable()
        
        XCTAssertEqual(first, first)
        XCTAssertNotEqual(first, second)
        XCTAssertEqual(second, second)
    }
    
    private struct SomeRouteable<T>: Routeable where T: Equatable {
        
        var value: T
        
    }

}
