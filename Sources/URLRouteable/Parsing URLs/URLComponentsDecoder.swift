import Foundation.NSURL

/// A type that can decode the contents of a `URL` into another type.
public protocol URLComponentsDecoder {
    
    /// The represented type this decoder will interpolate from a `URL`.
    associatedtype Representation
    
    /// Decodes the provided `URL` into the `Representation` type.
    ///
    /// - Parameter url: The `URL` representing an instance of the `Representation` type.
    /// - Throws: `URLParsingError`
    func decode(from url: URL) throws -> Representation
    
}
