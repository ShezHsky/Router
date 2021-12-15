import RouterCore
import struct Logging.Logger

struct SwiftLogRouteLogger {
    
    let logger: Logger
    let level: Logger.Level
    
    private func log(_ message: Logger.Message) {
        logger.log(level: level, message)
    }
    
}

// MARK: - SwiftLogRouteLogger + RouteLogger

extension SwiftLogRouteLogger: RouteLogger {
    
    func route<R>(_ route: R, willBeInvokedWith parameter: R.Parameter) where R: Route {
        log("\(type(of: route)) is routing \(String(describing: parameter))")
    }
    
    func route<R>(_ route: R, wasInvokedWith parameter: R.Parameter) where R: Route {
        log("\(type(of: route)) finished routing \(String(describing: parameter))")
    }
    
}

// MARK: - Convenience Logging

extension Route {
    
    /// Returns a `Route` that forwards `Routeable`s to the receiver, logging them via a swift-log in the process.
    ///
    /// - Parameter logger: A swift-log `Logger` configured by your app to write logging events to.
    /// - Parameter level: The `Logger.Level` in which routing log statements will be logged as.
    /// - Returns: A `LoggingRoute` that decorates the receiver with added logging support.
    public func logging(logger: Logger, level: Logger.Level = .debug) -> LoggingRoute<Self> {
        logging(logger: SwiftLogRouteLogger(logger: logger, level: level))
    }
    
}
