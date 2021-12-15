import Logging
import RouterCore
import SwiftLogRouteLogger
import XCTest
import XCTRouter

class SwiftLogRouteLoggerTests: XCTestCase {
    
    func testLogging() {
        let handler = SpyLogHandler()
        let logger = Logger(label: "Label", factory: { (_) in handler })
        let route = DummyRoute()
        let routeLogger = SwiftLogRouteLogger(logger: logger)
        let loggingRoute = route.logging(logger: routeLogger)
        loggingRoute.route(DummyRouteable(value: "Hello, World"))
        
        let expected: [SpyLogHandler.Event] = [
            .init(level: .debug, message: "DummyRoute is routing DummyRouteable(value: \"Hello, World\")"),
            .init(level: .debug, message: "DummyRoute finished routing DummyRouteable(value: \"Hello, World\")")
        ]
        
        XCTAssertEqual(expected, handler.logEvents)
    }
    
    private struct DummyRoute: Route {
        
        typealias Parameter = DummyRouteable
        
        func route(_ parameter: DummyRouteable) {
            
        }
        
    }
    
    private struct DummyRouteable: Routeable {
        
        var value: String
        
    }
    
    private class SpyLogHandler: LogHandler {
        
        subscript(metadataKey key: String) -> Logger.Metadata.Value? {
            get {
                metadata[key]
            }
            set(newValue) {
                metadata[key] = newValue
            }
        }
        
        var metadata: Logger.Metadata = Logger.Metadata()
        var logLevel: Logger.Level = .debug
        
        private(set) var logEvents = [Event]()
        
        struct Event: Equatable {
            var level: Logger.Level
            var message: Logger.Message
        }
        
        func log(
            level: Logger.Level,
            message: Logger.Message,
            metadata: Logger.Metadata?,
            source: String,
            file: String,
            function: String,
            line: UInt
        ) {
            logEvents.append(Event(level: level, message: message))
        }
        
    }
    
}
