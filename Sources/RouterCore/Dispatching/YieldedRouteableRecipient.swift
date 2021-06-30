/// A type that acts as the recipient of yielded `Routeable`s.
public protocol YieldedRouteableRecipient {
    
    /// Consumes the typed yielded `Routeable`.
    ///
    /// The `YieldsRouteable` protocol will invoke this function at least once for a `Routeable`, in which this
    /// recipient must handle before receiving zero or more `Routeable`s.
    ///
    /// - Parameter content: A `Routeable` yielded from a `YieldsRouteable`.
    func receive<Content>(_ content: Content) where Content: Routeable
    
}
