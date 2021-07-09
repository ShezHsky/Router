import Foundation.NSURL
import RouterCore
import URLDecoder

extension URLRouteable {
    
    /// Registers a new `Routeable` for later yielding by this type, in which the type can be decoded from a `URL`
    /// through its conformance to the `Decodable` protocol.
    /// - Parameter type: A type that conforms to the `Decodable` and `Routeable` protocols. This type will later be
    ///                   instantiated on demand by decoding the inbound `URL` via the types `init(decoder:)`
    ///                   implementation (synthesized or otherwise).
    public func registerURL<T>(_ type: T.Type) where T: Routeable & Decodable {
        register(DecoderProxy<T>.self)
    }
    
    fileprivate struct DecoderProxy<T> where T: Decodable & Routeable {
        
        let routeable: T
        
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
