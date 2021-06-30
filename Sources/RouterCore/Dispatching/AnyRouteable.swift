/// A type-erased `Routeable` value.
///
/// The `AnyRouteable` type forwards equality comparisons to an underlying routeable value, hiding the type of the
/// wrapped value.
public struct AnyRouteable {
    
    let erasedContent: Any
    private let descriptor: (YieldedRouteableRecipient) -> Void
    private let equals: (AnyRouteable) -> Bool
    
    public init<R>(_ content: R) where R: Routeable {
        self.erasedContent = content
        
        descriptor = { (recipient) in
            recipient.receive(content)
        }
        
        equals = { (other) in
            guard let castedOther = other.erasedContent as? R else { return false }
            return content == castedOther
        }
    }
    
}

// MARK: - AnyRouteable + CustomStringConvertible

extension AnyRouteable: CustomStringConvertible {
    
    public var description: String {
        String(describing: erasedContent)
    }
    
}

// MARK: - AnyRouteable + CustomReflectable

extension AnyRouteable: CustomReflectable {
    
    public var customMirror: Mirror {
        Mirror(reflecting: erasedContent)
    }
    
}

// MARK: - AnyRouteable + Equatable

extension AnyRouteable: Equatable {
    
    public static func == (lhs: AnyRouteable, rhs: AnyRouteable) -> Bool {
        lhs.equals(rhs)
    }
    
}

// MARK: - AnyRouteable + Routeable

extension AnyRouteable: Routeable { }

// MARK: - AnyRouteable + RouteableDescribing

extension AnyRouteable: YieldsRoutable {
    
    public func yield(to recipient: YieldedRouteableRecipient) {
        descriptor(recipient)
    }
    
}

// MARK: - Convenience Erasure

extension Routeable {
    
    /// Wraps this routeable with a type eraser.
    ///
    /// Use `eraseToAnyRouteable()` to expose an instance of `Routeable` in your app across API boundaries, erasing
    /// the underlying type.
    ///
    /// - Returns: An `AnyRouteable` wrapping this routeable.
    public func eraseToAnyRouteable() -> AnyRouteable {
        AnyRouteable(self)
    }
    
}
