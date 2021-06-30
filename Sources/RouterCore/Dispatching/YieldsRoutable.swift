/// A type that provides one or more `Routeable`s.
///
/// The content graph of your app may support routing to content from several places, where the underlying
/// representation of the route does not change. Decorating such routeables and confirming to this protocol enables
/// additional use cases to instigate such routes without leaking this knowledge throughout your presentation stack.
public protocol YieldsRoutable {
    
    /// Attempts to yield a `Routeable` to the provided recipient.
    ///
    /// Deeply nested `Routeable`s allow your content graph to remain flexible in the face of changing routing
    /// requirements. For example, you may start with a `Routeable` that takes you to an event type:
    ///
    /// ```
    /// struct EventRouteable: Routeable {
    ///     var identifier: UUID
    /// }
    /// ```
    ///
    /// This `Routeable` may be submitted to a router from within your app in response to user actions. Later, to
    /// handle deep linking, you may use a URL routeable that yields the `EventRouteable`:
    ///
    /// ```
    /// struct URLRouteable: Routeable {
    ///     var url: URL
    ///     func yield(to recipient: YieldedRouteableRecipient) {
    ///         // ... if url contains event ID
    ///         recipient.receive(EventRouteable(identifier: eventIdentifierFromPath))
    ///     }
    /// }
    /// ```
    ///
    /// Even later this URL may be encoded into an NDEF NFC tag, and so on. Each parent `Routeable` decides how to
    /// yield a child `Routeable`, without a change to how the routes are instigated.
    ///
    /// - Parameter recipient: A type that consumes the yielded `Routeable`.
    func yield(to recipient: YieldedRouteableRecipient)
    
}
