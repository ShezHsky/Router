import Foundation.NSURL
import RouterCore
import URLDecoder

extension URLRouteable {
    
    /// Registers a new `Routeable` for later yielding by this type, where the type unwraps itself from a `URL`.
    /// - Parameter type: A type that conforms to the `ExpressibleByURL` and `Routeable` protocols. This type will later
    ///                   be instantiated on demand when a matching `URL` is supplied to this routeable.
    public func registerURL<T>(_ type: T.Type) where T: ExpressibleByURL & Routeable {
        register(Proxy<T>.self)
    }
    
    public func registerURL<T>(_ type: T.Type, decoder: URLDecoder) where T: Decodable & Routeable {
        register(DecoderProxy<T>(decoder: decoder))
    }
    
    fileprivate struct Proxy<T> where T: Routeable & ExpressibleByURL {
        
        let routeable: T
        
    }
    
    private struct DecoderProxy<T>: ExternallyRepresentedRouteableFactory where T: Decodable & Routeable {
        
        typealias Representation = URL
        typealias RepresentedRouteable = T
        
        let decoder: URLDecoder
        
        func makeRouteable(for representation: URL) -> T? {
            do {
                return try decoder.decode(T.self, from: representation)
            } catch {
                return nil
            }
        }
        
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
