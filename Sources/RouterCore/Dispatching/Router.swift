/// A type that is used to dispatch a `Routeable` to an aggregate of `Route`s.
public protocol Router: RouteableDispatching {
    
    /// Submits the provided `Routeable` to compatible registered `Routes` within this router.
    /// 
    /// - Parameter content: The `Routeable` object to submit to any registered routes.
    /// - Throws: `RouteMissing` when no `Route` is registered for the provided `Routeable`.
    func route<R>(_ content: R) throws where R: Routeable
    
}

extension Router {
    
    public func dispatch<R>(routable: R) -> RouteDispatchResult where R: Routeable {
        do {
            try route(routable)
            return .dispatched
        } catch {
            return .notDispatched
        }
    }
    
}
