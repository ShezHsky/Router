import RouterCore
import struct Logging.Logger

public struct SwiftLogRouteLogger {
    
    private let logger: Logger
    
    public init(logger: Logger) {
        self.logger = logger
    }
    
}

// MARK: - SwiftLogRouteLogger + RouteLogger

extension SwiftLogRouteLogger: RouteLogger {
    
    public func route<R>(_ route: R, willBeInvokedWith parameter: R.Parameter) where R: Route {
        logger.log(
            level: .debug,
            "\(type(of: route)) is routing \(String(describing: parameter))"
        )
    }
    
    public func route<R>(_ route: R, wasInvokedWith parameter: R.Parameter) where R: Route {
        logger.log(
            level: .debug,
            "\(type(of: route)) finished routing \(String(describing: parameter))"
        )
    }
    
}
