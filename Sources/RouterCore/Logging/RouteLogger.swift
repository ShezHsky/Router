/// A type that records the presence of a `Routeable` from `Route`.
public protocol RouteLogger {
    
    /// Logs that the invocation of a `Route` with a specified `Routeable` is about to occur.
    ///
    /// This function will be called exactly once per invocation of the `Route`. Once this function returns, the route
    /// will be invoked.
    ///
    /// - Parameters:
    ///   - route: The `Route` that is about to be invoked.
    ///   - parameter: The `Routeable` that the associated `Route` will be invoked with.
    func route<R>(_ route: R, willBeInvokedWith parameter: R.Parameter) where R: Route
    
    /// Logs that the invocation of a `Route` with a specified `Routeable` has occurred.
    ///
    /// This function will be called exactly once per invocation of the `Route`. This function is invoked immediatley
    /// after the invocation of the route has occurred.
    ///
    /// - Parameters:
    ///   - route: The `Route` that has just been invoked.
    ///   - parameter: The `Routeable` that the associated `Route` has been invoked with.
    func route<R>(_ route: R, wasInvokedWith parameter: R.Parameter) where R: Route
    
}
