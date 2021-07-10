import Foundation.NSURL
import RouterCore

extension URLRouteable {
    
    /// Registers a new `Routeable` for later yielding by this type, where the type unwraps itself from a `URL`.
    /// - Parameter type: A type that conforms to the `ExpressibleByURL` and `Routeable` protocols. This type will later
    ///                   be instantiated on demand when a matching `URL` is supplied to this routeable.
    public func registerURL<T>(_ type: T.Type) where T: Routeable & ExpressibleByURL {
        register(Proxy<T>.self)
    }
    
    fileprivate struct Proxy<T> where T: Routeable & ExpressibleByURL {
        
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
