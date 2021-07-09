import Foundation.NSURL
import RouterCore
import URLDecoder

/// A `Routeable` type represented by an underlying `URL`.
///
/// Instances of `Routeable` types using `URL`s is fairly common, especially for apps that support universal links.
/// Clients should subclass this type and supply a series of `Routeable` types that can be initialized using `URL`s.
/// Later, instantiating the subclass with a `URL` will attempt to yield the corresponding `Routeable` when provided
/// to a router.
///
///```
/// class AppURLRouteable: URLRouteable {
///     override func registerRouteables() {
///         registerNotification(AppRouteable.self) // where AppRouteable conforms to Routeable & ExpressibleByURL
///     }
/// }
/// ```
///
/// - Note:
/// If your app submits a URL that cannot be decoded into a representitive routeable, this type will instead yield
/// a `UnknownURLRouteable`. Your app may configure a route to handle this type in order to alert the user that the
/// content could not be found.
open class URLRouteable: ExternallyRepresentedRouteable<URL> {
    
    /// Registers a new `Routeable` for later yielding by this type, where the type unwraps itself from a `URL`.
    /// - Parameter type: A type that conforms to the `ExpressibleByURL` and `Routeable` protocols. This type will later
    ///                   be instantiated on demand when a matching `URL` is supplied to this routeable.
    public func registerURL<T>(_ type: T.Type) where T: Routeable & ExpressibleByURL {
        register(Proxy<T>.self)
    }
    
    /// Registers a new `Routeable` for later yielding by this type, in which the type can be decoded from a `URL`
    /// through its conformance to the `Decodable` protocol.
    /// - Parameter type: A type that conforms to the `Decodable` and `Routeable` protocols. This type will later be
    ///                   instantiated on demand by decoding the inbound `URL` via the types `init(decoder:)`
    ///                   implementation (synthesized or otherwise).
    public func registerURL<T>(_ type: T.Type) where T: Routeable & Decodable {
        register(DecoderProxy<T>.self)
    }
    
    open override func failedToYieldRouteable(to recipient: YieldedRouteableRecipient) {
        recipient.receive(UnknownURLRouteable(url: representitiveValue))
    }
    
    public final override func equals(_ other: ExternallyRepresentedRouteable<URL>) -> Bool {
        representitiveValue == other.representitiveValue
    }
    
    fileprivate struct Proxy<T> where T: Routeable & ExpressibleByURL {
        
        let routeable: T
        
    }
    
    fileprivate struct DecoderProxy<T> where T: Decodable & Routeable {
        
        let routeable: T
        
    }
    
}

// MARK: - URLRouteable.Proxy + ExpressibleByExternalRepresentation

extension URLRouteable.Proxy: ExpressibleByExternalRepresentation {
    
    typealias Representation = URL
    
    init?(representitiveValue: URL) {
        guard let routeable = T(url: representitiveValue) else { return nil }
        self.routeable = routeable
    }
    
}

// MARK: - URLRouteable.Proxy + Routeable

extension URLRouteable.Proxy: Routeable { }

// MARK: - URLRouteable.Proxy + YieldsRouteable

extension URLRouteable.Proxy: YieldsRoutable {
    
    func yield(to recipient: YieldedRouteableRecipient) {
        recipient.receive(routeable)
    }
    
}

// MARK: - URLRouteable.DecoderProxy + ExpressibleByExternalRepresentation

extension URLRouteable.DecoderProxy: ExpressibleByExternalRepresentation {
    
    typealias Representation = URL
    
    init?(representitiveValue: Representation) {
        let decoder = URLDecoder()
        
        do {
            self.routeable = try decoder.decode(T.self, from: representitiveValue)
        } catch {
            return nil
        }
    }
    
}

// MARK: - URLRouteable.DecoderProxy + Routeable

extension URLRouteable.DecoderProxy: Routeable { }

// MARK: - URLRouteable.DecoderProxy + YieldsRoutable

extension URLRouteable.DecoderProxy: YieldsRoutable {
    
    func yield(to recipient: YieldedRouteableRecipient) {
        recipient.receive(routeable)
    }
    
}
