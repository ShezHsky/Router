/// A `Route` that forwards all `Routeable`s to another `Route`, logging them in the process.
public struct LoggingRoute<Logged> where Logged: Route {
    
    private let route: Logged
    private let logger: RouteLogger
    
    public init(route: Logged, logger: RouteLogger) {
        self.route = route
        self.logger = logger
    }
    
}

// MARK: - LoggingRoute + Route

extension LoggingRoute: Route {
    
    public typealias Parameter = Logged.Parameter
    
    public func route(_ parameter: Logged.Parameter) {
        logger.route(route, willBeInvokedWith: parameter)
        route.route(parameter)
        logger.route(route, wasInvokedWith: parameter)
    }
    
}

// MARK: - Convenience Logging

extension Route {
    
    /// Returns a `Route` that forwards `Routeable`s to the receiver, logging them in the process.
    /// 
    /// - Parameter logger: A type that is used to log `Routeable`s.
    /// - Returns: A `LoggingRoute` that decorates the receiver with added logging support.
    public func logging(logger: RouteLogger) -> LoggingRoute<Self> {
        LoggingRoute(route: self, logger: logger)
    }
    
}
