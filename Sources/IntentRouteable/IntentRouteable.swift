#if canImport(Intents)

import Intents
import RouterCore

/// A `Routeable` type represented by an `INIntent`.
///
/// There are various scenarios whereby routing to a specific part of an app via an intent may be required, such as when
/// the app target must handle the intent in response to a Siri query requiring the `continueInApp` response code.
/// These routes are typically the same as deep linking into the app via a `URL`, or navigating to a specific piece of
/// content.
///
/// To take advantage of the same routes, your app should subclass the `IntentRouteable` type and register one or more
/// `Routeable` types that can be initialized using `INIntent` subclassed defined by your apps intent definition file.
/// Later, instantiating your custom subclass with an `INIntent` will attempt to yield the corresponding `Routeable`
/// when provided to a `Router`.
///
/// ```
/// class AppIntentRouteable: IntentRouteable {
///     override func registerRouteables() {
///         registerIntent(AppRouteable.self) // where AppRouteable conforms to Routeable & ExpressibleByIntent
///     }
/// }
/// ```
@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
open class IntentRouteable: ExternallyRepresentedRouteable<INIntent> {
    
    /// Registers a new `Routeable` for later yielding by this type.
    /// - Parameter type: A type that conforms to the `ExpressibleByIntent` and `Routeable` protocols. This type will
    ///                   later be instantiated on demand when a matching `INIntent` is supplied to this routeable.
    public func registerIntent<R>(_ routeable: R.Type) where R: Routeable & ExpressibleByIntent {
        register(Proxy<R>.self)
    }
    
    public final override func equals(_ other: ExternallyRepresentedRouteable<INIntent>) -> Bool {
        representitiveValue === other.representitiveValue
    }
    
    fileprivate struct Proxy<T> where T: Routeable & ExpressibleByIntent {
        
        let routeable: T
        
    }
    
}

// MARK: - IntentRouteable.Proxy + ExpressibleByExternalRepresentation

@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
extension IntentRouteable.Proxy: ExpressibleByExternalRepresentation {
    
    typealias Representation = INIntent
    
    init?(representitiveValue: INIntent) {
        guard let intent = representitiveValue as? T.Intent else { return nil }
        routeable = T(intent: intent)
    }
    
}

// MARK: - IntentRouteable.Proxy + Routeable

@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
extension IntentRouteable.Proxy: Routeable { }

// MARK: - IntentRouteable.Proxy + YieldsRouteable

@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
extension IntentRouteable.Proxy: YieldsRoutable {
    
    func yield(to recipient: YieldedRouteableRecipient) {
        recipient.receive(routeable)
    }
    
}

#endif
