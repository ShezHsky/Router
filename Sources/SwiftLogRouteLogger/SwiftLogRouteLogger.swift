import RouterCore
import struct Logging.Logger

public struct SwiftLogRouteLogger {
    
    private let logger: Logger
    private let level: Logger.Level
    
    public init(logger: Logger, level: Logger.Level = .debug) {
        self.logger = logger
        self.level = level
    }
    
    private func log(_ message: Logger.Message) {
        logger.log(level: level, message)
    }
    
}

// MARK: - SwiftLogRouteLogger + RouteLogger

extension SwiftLogRouteLogger: RouteLogger {
    
    public func route<R>(_ route: R, willBeInvokedWith parameter: R.Parameter) where R: Route {
        log("\(type(of: route)) is routing \(String(describing: parameter))")
    }
    
    public func route<R>(_ route: R, wasInvokedWith parameter: R.Parameter) where R: Route {
        log("\(type(of: route)) finished routing \(String(describing: parameter))")
    }
    
}
