import Foundation.NSUserActivity
import RouterCore
import URLRouteable

extension UserActivityRouteable {
    
    /// Registers a `URLRouteable` for later yielding by this type.
    ///
    /// Use this function to register your apps `URLRouteable` subclass that will be used to decode user activites
    /// backed by a web page URL.
    ///
    /// - Parameter type: The type of `URLRouteable` that will be used to attempt decoding of incoming activites.
    public func register<R>(_ type: R.Type) where R: URLRouteable {
        register { (userActivity) in
            guard let url = userActivity.webpageURL else { return nil }
            return R(url).eraseToAnyRouteable()
        }
    }
    
}
