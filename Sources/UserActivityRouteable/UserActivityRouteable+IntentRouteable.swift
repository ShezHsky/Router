import IntentRouteable
import RouterCore

@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
extension UserActivityRouteable {
    
    /// Registers an `IntentRouteable` for later yielding by this type.
    ///
    /// Use this function to register your apps `IntentRouteable` subclass that will be used to decode user activites
    /// backed by an intent.
    ///
    /// - Parameter type: The type of `IntentRouteable` that will be used to attempt decoding of incoming activites.
    @available(macOS, unavailable)
    public func register<R>(_ type: R.Type) where R: IntentRouteable {
        register { (userActivity) in
            guard let intent = userActivity.interaction?.intent else { return nil }
            return R(intent).eraseToAnyRouteable()
        }
    }
    
}
