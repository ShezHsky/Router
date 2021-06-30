import RouterCore
import XCTest
import XCTRouter

class RouterTests: XCTestCase {
    
    func testWellKnownRoute() {
        let content = WellKnownContent()
        let route = WellKnownContentRoute()
        var router = Routes()
        router.install(route)
        
        XCTAssertNoThrow(try router.route(content))
        
        XCTAssertEqual(content, route.routedContent)
    }
    
    func testRouteMissing() {
        let content = WellKnownContent()
        let router = Routes()
        
        XCTAssertThrowsError(try router.route(content))
    }
    
    func testTwoDifferentRoutes() {
        let route = WellKnownContentRoute()
        let anotherRoute = SomeOtherWellKnownContentRoute()
        let anotherRouteContent = SomeOtherWellKnownContent()
        var router = Routes()
        router.install(route)
        router.install(anotherRoute)
        
        XCTAssertNoThrow(try router.route(anotherRouteContent))
        
        XCTAssertEqual(anotherRouteContent, anotherRoute.routedContent)
    }
    
    func testTwoDifferentRoutes_InvokingFirstRoute() {
        let route = WellKnownContentRoute()
        let anotherRoute = SomeOtherWellKnownContentRoute()
        let routeContent = WellKnownContent()
        var router = Routes()
        router.install(route)
        router.install(anotherRoute)
        
        XCTAssertNoThrow(try router.route(routeContent))
        
        XCTAssertEqual(routeContent, route.routedContent)
    }
    
    func testLastMostRegisteredRouteForSameContentTypeWins() {
        let content = WellKnownContent()
        let firstRoute = WellKnownContentRoute()
        let secondRoute = WellKnownContentRoute()
        var router = Routes()
        router.install(firstRoute)
        router.install(secondRoute)
        
        XCTAssertNoThrow(try router.route(content))
        
        XCTAssertNil(firstRoute.routedContent)
        XCTAssertEqual(content, secondRoute.routedContent)
    }
    
    func testComplexContentPassedToExpectedRoute() {
        let content = WellKnownContent()
        let complexContent = WrapperContent(inner: content)
        let route = WellKnownContentRoute()
        var router = Routes()
        router.install(route)
        
        XCTAssertNoThrow(try router.route(complexContent))
        
        XCTAssertEqual(content, route.routedContent)
    }
    
    func testDeeplyNestedRouteablesYieldExpectedRouteable() {
        let content = WellKnownContent()
        let firstLevel = WrapperContent(inner: content)
        let secondLevel = WrapperContent(inner: firstLevel)
        let thirdLevel = WrapperContent(inner: secondLevel)
        let recipient = CapturingRouteableRecipient()
        thirdLevel.recursivleyYield(to: recipient)
        
        XCTAssertEqual(content.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    func testImperativelyNestingRoutes() throws {
        let route = WellKnownContentRoute()
        var topLevelRoutes = Routes()
        var childRoutes = Routes()
        childRoutes.install(route)
        topLevelRoutes.install(childRoutes)
        let content = WellKnownContent()
        try topLevelRoutes.route(content)
        
        XCTAssertEqual(content, route.routedContent)
    }
    
    func testImperativelyNestingRouteProviders() throws {
        let route = WellKnownContentRoute()
        var routes = Routes()
        let provider = ProvidesOneRoute(route: route)
        routes.install(provider)
        let content = WellKnownContent()
        try routes.route(content)
        
        XCTAssertEqual(content, route.routedContent)
    }
    
    private struct ProvidesOneRoute<R>: RouteProvider where R: Route {
        
        var route: R
        
        var routes: Routes {
            Routes {
                route
            }
        }
        
    }
    
}
