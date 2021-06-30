/// A type that is cable of dispatching a `Routeable`.
public protocol RouteableDispatching: RouteProvider {
    
    /// Dispatches the given `Routeable` into the system, providing an indicator whether the `Routeable` was handled.
    ///
    /// - Parameter routable: The `Routeable` to be dispatched.
    /// - Returns: A `RouteDispatchResult` indicating whether a type handled the incoming `Routeable`.
    func dispatch<R>(routable: R) -> RouteDispatchResult where R: Routeable
    
}

// MARK: - RouteProvider

extension RouteableDispatching {
    
    public var routes: Routes {
        Routes(children: [self])
    }
    
}
