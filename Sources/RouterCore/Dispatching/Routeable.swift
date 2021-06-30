/// A type that can be ingested by a `Router`.
///
/// `Routeable` types act as stateless identifiers for content in your app, allowing `Route`s to perform the necessary
/// lookup and presentation of the underlying content. They may be sourced from various parts of your app, such as
/// direct instantiation from a controller or conversion of an external content type (e.g. a URL). For this reason,
/// use of value types to represent `Routeable`s is encouraged.
public protocol Routeable: Equatable { }

// MARK: - Recursive Evaluation

extension Routeable {
    
    /// Recursivley yields this `Routeable` until finding a type that cannot be yielded, describing that type to the
    /// recipient.
    ///
    /// For more information on yielding `Routeable`s, see `YieldsRoutable.yield(to:)`
    public func recursivleyYield(to recipient: YieldedRouteableRecipient) {
        let unwrapper = RecursiveRouteableUnwrapper(recipient: recipient)
        unwrapper.receive(self)
    }
    
}

private struct RecursiveRouteableUnwrapper: YieldedRouteableRecipient {
    
    var recipient: YieldedRouteableRecipient
    
    func receive<Content>(_ content: Content) where Content: Routeable {
        if let yielder = content as? YieldsRoutable {
            yielder.yield(to: self)
        } else {
            recipient.receive(content)
        }
    }
    
}
