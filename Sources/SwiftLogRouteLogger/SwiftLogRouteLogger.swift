import RouterCore
import func Foundation.NSLocalizedString
import struct Logging.Logger

struct SwiftLogRouteLogger {
    
    let logger: Logger
    let level: Logger.Level
    
    private func log<R>(localizedFormat: String, route: R, parameter: R.Parameter) where R: Route {
        let message = String.localizedStringWithFormat(
            localizedFormat,
            "\(type(of: route))",
            String(describing: parameter)
        )
        
        logger.log(level: level, Logger.Message(stringLiteral: message))
    }
    
}

// MARK: - SwiftLogRouteLogger + RouteLogger

extension SwiftLogRouteLogger: RouteLogger {
    
    func route<R>(_ route: R, willBeInvokedWith parameter: R.Parameter) where R: Route {
        let format = NSLocalizedString(
            "%@ is routing %@",
            bundle: .module,
            comment: "Logging format string used when printing just before a route is invoked"
        )
        
        log(localizedFormat: format, route: route, parameter: parameter)
    }
    
    func route<R>(_ route: R, wasInvokedWith parameter: R.Parameter) where R: Route {
        let format = NSLocalizedString(
            "%@ finished routing %@",
            bundle: .module,
            comment: "Logging format string used when printing just after a route is invoked"
        )
        
        log(localizedFormat: format, route: route, parameter: parameter)
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
