import Foundation.NSURL

/// A type that can be initialized using a `URL`.
public protocol ExpressibleByURL {
    
    /// Creates an instance initialized to the given `URL` value.
    /// - Parameter url: The value of the new instance.
    init?(url: URL)
    
}
