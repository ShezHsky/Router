/// A `RouteLogger` that emits logging to the standard output.
public struct SystemOutRouteLogger {
    
    private let prefix: String
    
    /// Initializes a new logger that prefixes all messages.
    /// - Parameter prefix: A prefix to apply to all messages to the standard output, used for filtering by the
    ///                     developer.
    public init(prefix: String = "") {
        self.prefix = prefix
    }
    
}

// MARK: - SystemOutRouteLogger + RouteLogger

extension SystemOutRouteLogger: RouteLogger {
    
    public func route<R>(_ route: R, willBeInvokedWith parameter: R.Parameter) where R: Route {
        print("\(prefix)Will invoke \(makeRouteAndParameterDescription(route, parameter))")
    }
    
    public func route<R>(_ route: R, wasInvokedWith parameter: R.Parameter) where R: Route {
        print("\(prefix)Did invoke \(makeRouteAndParameterDescription(route, parameter))")
    }
    
    private func makeRouteAndParameterDescription<R>(_ route: R, _ parameter: R.Parameter) -> String where R: Route {
        let routeName = String(describing: R.self)
        let parameterDescription = String(describing: parameter)
        
        return "\(routeName)(\(parameterDescription))"
    }
    
}

// MARK: - Convenience Logging

extension Route {
    
    /// Returns a `Route` that forwards `Routeable`s to the receiver, logging them to the standard output in the
    ///  process.
    ///
    /// - Parameter prefix: A prefix to apply to all messages to the standard output, used for filtering by the
    ///                     developer.
    /// - Returns: A `LoggingRoute` that decorates the receiver with added logging support.
    public func logging(prefix: String = "") -> LoggingRoute<Self> {
        logging(logger: SystemOutRouteLogger(prefix: prefix))
    }
    
}
