import RouterCore
import XCTest

class DSLTests: XCTestCase {
    
    func testOneTopLevelRouteUsingDSL() {
        let content = WellKnownContent()
        let route = WellKnownContentRoute()
        let router = Routes {
            route
        }
        
        XCTAssertNoThrow(try router.route(content))
        
        XCTAssertEqual(content, route.routedContent)
    }
    
    func testTwoTopLevelRoutesUsingDSL() {
        let secondRoute = TemplatedRoute<TemplatedRouteable<Int8>>()
        let routes = Routes {
            TemplatedRoute<TemplatedRouteable<Int>>()
            secondRoute
        }
        
        let secondRouteable = TemplatedRouteable<Int8>(value: 8)
        
        XCTAssertNoThrow(try routes.route(secondRouteable))
        XCTAssertEqual(secondRouteable, secondRoute.routed)
    }
    
    func testThreeTopLevelRoutesUsingDSL() {
        let thirdRoute = TemplatedRoute<TemplatedRouteable<Int16>>()
        let routes = Routes {
            TemplatedRoute<TemplatedRouteable<Int>>()
            TemplatedRoute<TemplatedRouteable<Int8>>()
            thirdRoute
        }
        
        let thirdRouteable = TemplatedRouteable<Int16>(value: 16)
        
        XCTAssertNoThrow(try routes.route(thirdRouteable))
        XCTAssertEqual(thirdRouteable, thirdRoute.routed)
    }
    
    func testConditionallyRemovedRouteIsNotAvailable() throws {
        let firstRoute = WellKnownContentRoute()
        let secondRoute = SomeOtherWellKnownContentRoute()
        let alwaysExecuteTruthyPath = true
        
        let routes = Routes {
            if alwaysExecuteTruthyPath {
                firstRoute
            } else {
                secondRoute
            }
        }
        
        XCTAssertNoThrow(try routes.route(WellKnownContent()))
        XCTAssertNotNil(firstRoute.routedContent)
        XCTAssertThrowsError(try routes.route(SomeOtherWellKnownContent()))
        XCTAssertNil(secondRoute.routedContent)
    }
    
    func testMixingConditionalWithNonConditionalRoutes() {
        let wellKnownContentRoute = WellKnownContentRoute()
        let templatedRoute = TemplatedRoute<TemplatedRouteable<String>>()
        let someOtherWellKnownContentRoute = SomeOtherWellKnownContentRoute()
        let executeTruthyPath = false
        
        let routes = Routes {
            wellKnownContentRoute
            
            if executeTruthyPath {
                TemplatedRoute<TemplatedRouteable<Int>>()
            } else {
                templatedRoute
            }
            
            someOtherWellKnownContentRoute
        }
        
        XCTAssertNoThrow(try routes.route(WellKnownContent()))
        XCTAssertThrowsError(try routes.route(TemplatedRouteable<Int>(value: 42)))
        XCTAssertNoThrow(try routes.route(SomeOtherWellKnownContent()))
        XCTAssertNoThrow(try routes.route(TemplatedRouteable<String>(value: "Hello, world")))
    }
    
    func testBuildingRoutesUsingSwitchStatement() {
        let wellKnownContentRoute = WellKnownContentRoute()
        let someOtherWellKnownContentRoute = SomeOtherWellKnownContentRoute()
        let someDomainValue = 42
        
        let routes = Routes {
            switch someDomainValue {
            case 42:
                wellKnownContentRoute
                
            default:
                someOtherWellKnownContentRoute
            }
        }
        
        XCTAssertNoThrow(try routes.route(WellKnownContent()))
        XCTAssertThrowsError(try routes.route(SomeOtherWellKnownContent()))
    }
    
    func testBuildingRoutesUsingProviderType() throws {
        let wellKnownContentRoute = WellKnownContentRoute()
        let provider = WellKnownContentRouteProvider(subRoute: wellKnownContentRoute)
        
        let routes = Routes {
            provider
        }
        
        try routes.route(WellKnownContent())
        
        XCTAssertNotNil(wellKnownContentRoute.routedContent)
    }
    
    func testUsingAccessorToDispatcherEnablesCrossRoutePosting() throws {
        struct PostWellKnownContentFromRoute: Route {
            
            var dispatcher: Router
            
            func route(_ parameter: SomeOtherWellKnownContent) {
                try? dispatcher.route(WellKnownContent())
            }
            
        }
        
        let wellKnownContentRoute = WellKnownContentRoute()
        let routes = Routes { (dispatcher) in
            PostWellKnownContentFromRoute(dispatcher: dispatcher)
            wellKnownContentRoute
        }
        
        try routes.route(SomeOtherWellKnownContent())
        
        XCTAssertNotNil(wellKnownContentRoute.routedContent)
    }
    
}
