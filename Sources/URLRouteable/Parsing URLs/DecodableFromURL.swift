import Foundation.NSURL
import RouterCore

/// A type that can be initialized by a `URL` through an intermediate representation.
public protocol DecodableFromURL: ExpressibleByURL {
    
    /// The type of object used to decode a `URL` into an intermediate representation.
    associatedtype ComponentsDecoder: URLComponentsDecoder
    
    /// Specifies the `ComponentsDecoder` used to decode a `URL` into an intermediate type, which can be used to later
    /// instantiate instances of this type.
    static var decoder: ComponentsDecoder { get }
    
    /// Creates an instance initialized using the given `Representation`, decoded from a `URL`.
    /// - Parameter context: The representitive value of the `URL` the new instance is initialized to.
    init(context: ComponentsDecoder.Representation)
    
}

// MARK: - ExpressibleByURL Convenience

extension DecodableFromURL {
    
    public init?(url: URL) {
        guard let context = try? Self.decoder.decode(from: url) else { return nil }
        self.init(context: context)
    }
    
}
