/// A type that is capable of invoking behaviour in response to receiving a `Routeable`.
///
/// In your app, most if not all `Route`s will likely either:
///
/// - Present a view controller or adjust the presentation of a view
/// - Adjust the model used by a SwiftUI
///
/// However `Route`s are not limited to presentation behaviour - they may be used to process events or action other
/// non user-facing behaviour.
///
/// - Important:
/// `Route`s should remain stateless, and not remember anything about their previous invocations. State relevant to the
/// route being invoked should be held by your app that is invoked in response to this `Route` being executed. For this
/// reason, using value types is preferred.
public protocol Route: RouteableDispatching {
    
    /// The type of `Routeable` this `Route` can handle.
    associatedtype Parameter: Routeable
    
    /// Invokes the behaviour of this `Route` using the provided `Routeable` to customise the behaviour.
    ///
    /// In the implementation of your `Route`, use the information in the provided `Routeable` to perform the
    /// necessary lookup of the data needed to action this route. Use this fetched data to configure the user
    /// interface, or action other non visual behaviour.
    ///
    /// - Parameter parameter: An instance of the `Routeable` this `Route` can action.
    func route(_ parameter: Parameter)
    
}

// MARK: - Convenience RouteableDispatching Implementation

extension Route {
    
    public func dispatch<R>(routable: R) -> RouteDispatchResult where R: Routeable {
        var result: RouteDispatchResult = .notDispatched
        if let parameter = routable as? Self.Parameter {
            route(parameter)
            result = .dispatched
        }
        
        return result
    }
    
}
