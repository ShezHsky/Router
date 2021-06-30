import RouterCore
import XCTest

class Route_RouteDispatchableTests: XCTestCase {
    
    func testSameTypeAsParameterInvokesRoute() {
        let route = WellKnownContentRoute()
        let parameter = WellKnownContent()
        let result = route.dispatch(routable: parameter)
        
        XCTAssertEqual(parameter, route.routedContent)
        XCTAssertEqual(.dispatched, result)
    }
    
    func testDifferentTypeFromParameterDoesNotInvokeRoute() {
        let route = WellKnownContentRoute()
        let parameter = SomeOtherWellKnownContent()
        let result = route.dispatch(routable: parameter)
        
        XCTAssertEqual(.notDispatched, result)
    }
    
}
