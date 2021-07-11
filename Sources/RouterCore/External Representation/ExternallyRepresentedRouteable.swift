/// A `Routeable` that is defined by the representation of an external value.
///
/// Using a routeable type directly is the most succinct clear way to invoke routes in your app. However, external
/// triggers such as deep links make this process tricky as the semantic value of the routeable is lost.
///
/// The `ExternallyRepresentedRouteable` models this scenario by expressing a routeable which is generic over an
/// external type, whereby your app may register one or more types capable of handling the representation. When
/// submitted to a router, the routeable lazily evaluates the implementation provided by your app.
///
/// The router package offers several implementations of this routeable for a few common app scenarios, including:
///
/// - URLs (`URLRouteable`)
/// - Siri Intents (`IntentRouteable`)
/// - Notifications (`NotificationRouteable`)
///
/// However your app may subclass `ExternallyRepresentedRouteable` directly to provide a custom implementation as
/// required.
open class ExternallyRepresentedRouteable<ExternalRepresentation> {
    
    /// The `ExternalRepresentation` used to initialize this routeable.
    public let representitiveValue: ExternalRepresentation
    
    private var decoders = [RegisteredDecoder]()
    
    /// Initializes a routeable backed by an externally represented value.
    /// - Parameter representitiveValue: The external representation of this route.
    public required init(_ representitiveValue: ExternalRepresentation) {
        self.representitiveValue = representitiveValue
        registerRouteables()
    }
    
    /// Provides a convenient hook for subclasses to register their `Routeable` types for later instantiation.
    open func registerRouteables() {
        
    }
    
    /// Provides a template method for subclasses to customise the yielding behaviour when no routeable can be decoded
    /// from the representitive value.
    ///
    /// Subclasses should override this method to provide support for scenarios where the `ExternalRepresentation` used
    /// to initialize this instance failed to appropriatley decode a routeable. The reason for this failure is specific
    /// to the decoding policy of the subclass, however it will typically occur in response to unexpected input to the
    /// decoding process (e.g. bad formatting, missing values, etc).
    ///
    /// Your subclass may yield a seperate routeable for this scenario if it makes sense for your app, such as a default
    /// value, or perform additional decoding work to try and refine what the intent behind the original representation
    /// was.
    ///
    /// - Note:
    /// This function will be called exactly zero or one times during the invocation of `yield(to:)`. The default
    /// implementation does nothing.
    ///
    /// - Parameter recipient: The `YieldedRouteableRecipient` provided to the `yield(to:)` method, where no routeable
    ///                        was yielded.
    open func failedToYieldRouteable(to recipient: YieldedRouteableRecipient) {
        
    }
    
    /// Registers a new `Routeable` for later yielding by this type.
    /// - Parameter type: A type that conforms to the `ExpressibleByExternalRepresentation` and `Routeable` protocols.
    ///                   This type will later be instantiated on demand upon yielding this routeable to a router.
    public func register<T: Routeable & ExpressibleByExternalRepresentation>(_ type: T.Type)
        where T.Representation == ExternalRepresentation
    {
        decoders.append(RegisteredDecoder(T.self))
    }
    
    /// Registers a factory object that produces a `Routeable` at a later time on receipt of an external representation.
    /// - Parameter factory: A factory object that is capable of transforming instances of the `ExternalRepresentation`
    ///                      into a `Routeable`.
    public func register<Factory>(_ factory: Factory)
        where Factory: ExternallyRepresentedRouteableFactory, Factory.Representation == ExternalRepresentation
    {
        decoders.append(RegisteredDecoder(factory))
    }
    
    /// Performs an equality test between the receiver and another instance.
    /// - Parameter other: The `ExternallyRepresentedRouteable` to compare against
    /// - Returns: `true` if `self` and `other` are equal, `false` otherwise.
    open func equals(_ other: ExternallyRepresentedRouteable) -> Bool {
        self === other
    }
    
    private struct RegisteredDecoder {
        
        private let _decode: (ExternalRepresentation) -> AnyRouteable?
        
        init<T: Routeable & ExpressibleByExternalRepresentation>(_ type: T.Type)
            where T.Representation == ExternalRepresentation
        {
            _decode = { (representitiveValue) in
                T(representitiveValue: representitiveValue)?.eraseToAnyRouteable()
            }
        }
        
        init<Factory>(_ factory: Factory)
            where Factory: ExternallyRepresentedRouteableFactory, Factory.Representation == ExternalRepresentation
        {
            _decode = { (representitiveValue) in
                factory.makeRouteable(for: representitiveValue)?.eraseToAnyRouteable()
            }
        }
        
        func decode(_ representation: ExternalRepresentation) -> AnyRouteable? {
            _decode(representation)
        }
        
    }
    
}

// MARK: - ExternallyRepresentedRouteable + Routeable

extension ExternallyRepresentedRouteable: Routeable {
    
    public static func == (lhs: ExternallyRepresentedRouteable, rhs: ExternallyRepresentedRouteable) -> Bool {
        lhs.equals(rhs)
    }
    
}

// MARK: - ExternallyRepresentedRouteable + YieldsRoutable

extension ExternallyRepresentedRouteable: YieldsRoutable {
    
    public func yield(to recipient: YieldedRouteableRecipient) {
        if let routeable = decodeRouteable() {
            recipient.receive(routeable)
        } else {
            failedToYieldRouteable(to: recipient)
        }
    }
    
    private func decodeRouteable() -> AnyRouteable? {
        for decoder in decoders {
            if let routeable = decoder.decode(representitiveValue) {
                return routeable
            }
        }
        
        return nil
    }
    
}
