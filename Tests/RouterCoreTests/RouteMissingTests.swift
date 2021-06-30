import RouterCore
import XCTest

class RouteMissingTests: XCTestCase {
    
    func testDescription() {
        let content = WellKnownContent()
        let error = RouteMissing(content: content)
        let expected = "No route configured for content represented by WellKnownContent"
        
        XCTAssertEqual(expected, error.description)
    }
    
}
