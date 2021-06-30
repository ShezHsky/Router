import RouterCore
import XCTest

class LoggingRouteTests: XCTestCase {
    
    func testOutputsToLoggerWhenInvoked() throws {
        let parameter = WellKnownContent()
        let logger = AssertsLoggingOccursInOrder(expectedParameter: parameter)
        let loggingRoute = logger.logging(logger: logger)
        
        _ = loggingRoute.dispatch(routable: parameter)
        
        try logger.verify()
    }
    
    private struct AssertionFailure: Error {
        var description: String
    }
    
    private class AssertsLoggingOccursInOrder<T>: RouteLogger, Route where T: Routeable {
        
        private enum Action {
            case willInvokeRoute(Any, Any)
            case invokedRoute(Parameter)
            case didInvokeRoute(Any, Any)
        }
        
        private let expectedParameter: Parameter
        private let line: UInt
        private var witnessedActions = [Action]()
        
        init(expectedParameter: Parameter, line: UInt = #line) {
            self.expectedParameter = expectedParameter
            self.line = line
        }
        
        typealias Parameter = T
        
        func route<R>(_ route: R, willBeInvokedWith parameter: R.Parameter) where R: Route {
            witnessedActions.append(.willInvokeRoute(route, parameter))
        }
        
        func route(_ parameter: Parameter) {
            witnessedActions.append(.invokedRoute(parameter))
        }
        
        func route<R>(_ route: R, wasInvokedWith parameter: R.Parameter) where R: Route {
            witnessedActions.append(.didInvokeRoute(route, parameter))
        }
        
        func verify(file: StaticString = #file, line: UInt = #line) throws {
            guard witnessedActions.count == 3 else {
                throw AssertionFailure(description: "Expected three events (will invoke, invoked, did invoke)")
            }
            
            try verifyFirstIsWillInvoke(witnessedActions[0])
            try verifySecondActionIsDidInvoke(witnessedActions[1])
            try verifyThirdActionIsDidInvoke(witnessedActions[2])
        }
        
        private func verifyFirstIsWillInvoke(_ action: Action) throws {
            guard case .willInvokeRoute(let route, let parameter) = action else {
                throw AssertionFailure(description: "First action should be route(_:willBeInvokedWith:)")
            }
            
            try assertExpected(route: route, parameter: parameter)
        }
        
        private func verifySecondActionIsDidInvoke(_ action: Action) throws {
            guard case .invokedRoute(let parameter) = action else {
                throw AssertionFailure(description: "Second action should be route(_:)")
            }
            
            XCTAssertEqual(expectedParameter, parameter, line: line)
        }
        
        private func verifyThirdActionIsDidInvoke(_ action: Action) throws {
            guard case .didInvokeRoute(let route, let parameter) = action else {
                throw AssertionFailure(description: "Third action should be route(_:wasInvokedWith:)")
            }
            
            try assertExpected(route: route, parameter: parameter)
        }
        
        private func assertExpected(route: Any, parameter: Any) throws {
            let castedRoute = try XCTUnwrap(route as? AssertsLoggingOccursInOrder<T>, line: line)
            let castedParameter = try XCTUnwrap(parameter as? Parameter, line: line)
            
            XCTAssertIdentical(self, castedRoute, line: line)
            XCTAssertEqual(expectedParameter, castedParameter, line: line)
        }
        
    }
    
}
