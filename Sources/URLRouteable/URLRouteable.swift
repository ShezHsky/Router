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
    
    open override func failedToYieldRouteable(to recipient: YieldedRouteableRecipient) {
        recipient.receive(UnknownURLRouteable(url: representitiveValue))
    }
    
    public final override func equals(_ other: ExternallyRepresentedRouteable<URL>) -> Bool {
        representitiveValue == other.representitiveValue
    }
    
}
