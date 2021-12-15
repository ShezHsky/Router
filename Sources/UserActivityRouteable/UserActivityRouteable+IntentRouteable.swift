import IntentRouteable
import RouterCore

@available(macOS 12.0, *, iOS 10.0, *, tvOS 14.0, watchOS 3.2, *)
extension UserActivityRouteable {
    
    /// Registers an `IntentRouteable` for later yielding by this type.
    ///
    /// Use this function to register your apps `IntentRouteable` subclass that will be used to decode user activites
    /// backed by an intent.
    ///
    /// - Parameter type: The type of `IntentRouteable` that will be used to attempt decoding of incoming activites.
    public func register<R>(_ type: R.Type) where R: IntentRouteable {
        register { (userActivity) in
            guard let intent = userActivity.interaction?.intent else { return nil }
            return R(intent).eraseToAnyRouteable()
        }
    }
    
}
