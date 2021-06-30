import Foundation.NSURL
import RouterCore

/// A routeable that designates an unhandled `URL` was submitted for routing.
///
/// This routeable is yielded from a `URLRouteable` when it cannot decode a representitive routeable from a URL. Your
/// app may register a route configured to handle this routeable in order to alert the user that the target content
/// could not be found.
public struct UnknownURLRouteable {
    
    /// The `URL` that was unable to be decoded by a `URLRouteable`.
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
}

// MARK: - UnknownURLRouteable + Routeable

extension UnknownURLRouteable: Routeable { }
