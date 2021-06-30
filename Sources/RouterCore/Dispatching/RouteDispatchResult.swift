/// Denotes the result of a dispatching operation against a `RouteableDispatching` type.
public enum RouteDispatchResult {
    
    /// The `Routeable` was handled by one or more dispatchers.
    case dispatched
    
    /// The `Routeable` was not handled by any dispatcher.
    case notDispatched
    
}
