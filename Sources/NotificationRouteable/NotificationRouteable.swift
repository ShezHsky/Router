import Foundation.NSDictionary
import RouterCore

/// A `Routeable` type represented by the user info dictionary of a local or remote notification.
///
/// Your app may require routing to a specific piece of content in response to handling a notification, such as a
/// chat log or an event. The user info dictionary typically references the destination content using a property list
/// compatible value, such as a string, to model an identifier for the content.
///
/// By subclassing the `NotificationRouteable` type in your app, you may express the supported notification routeables
/// in your app by registering routeable types that conform to the `ExpressibleByNotificationPayload` protocol. The
/// same routes used to explicitly perform navigation within your app can then be used in response to the routing of a
/// notification.
///
/// ```
/// class AppNotificationRouteable: NotificationRouteable {
///     override func registerRouteables() {
///         registerNotification(AppRouteable.self) // where AppRouteable conforms to Routeable & ExpressibleByNotificationPayload
///     }
/// }
/// ```
open class NotificationRouteable: ExternallyRepresentedRouteable<NotificationPayload> {
    
    /// Registers a new `Routeable` for later yielding by this type.
    /// - Parameter type: A type that conforms to the `ExpressibleByNotificationPayload` and `Routeable` protocols.
    ///                   This type will later be instantiated on demand when a notification is being routed.
    public func registerNotification<R>(_ type: R.Type) where R: Routeable & ExpressibleByNotificationPayload {
        register(Proxy<R>.self)
    }
    
    public final override func equals(_ other: ExternallyRepresentedRouteable<NotificationPayload>) -> Bool {
        NSDictionary(dictionary: representitiveValue).isEqual(to: other.representitiveValue)
    }
    
    fileprivate struct Proxy<T> where T: Routeable & ExpressibleByNotificationPayload {
        
        let routeable: T
        
    }
    
}

// MARK: - NotificationRouteable.Proxy + ExpressibleByExternalRepresentation

extension NotificationRouteable.Proxy: ExpressibleByExternalRepresentation {
    
    typealias Representation = NotificationPayload
    
    init?(representitiveValue: NotificationPayload) {
        guard let routeable = T(notificationPayload: representitiveValue) else { return nil }
        self.routeable = routeable
    }
    
}

// MARK: - NotificationRouteable.Proxy + Routeable

extension NotificationRouteable.Proxy: Routeable { }

// MARK: - NotificationRouteable.Proxy + YieldsRoutable

extension NotificationRouteable.Proxy: YieldsRoutable {
    
    func yield(to recipient: YieldedRouteableRecipient) {
        recipient.receive(routeable)
    }
    
}
