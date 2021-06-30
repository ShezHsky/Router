import Foundation.NSUserActivity
import RouterCore

/// A `Routeable` type represented by an `NSUserActivity`.
///
/// Most apps will represent content in their apps using an activity via either the `webpageURL` or `intent` property
/// of an activites `interaction`. These are heavily utilised by the system to support deep linking using universal
/// links or intents. Your app should subclass this routeable to specify the types of `IntentRouteable` and
/// `URLRouteable` also defined in your app to configure the behaviour of this routeable:
///
/// ```
/// class AppUserActivityRouteable: UserActivityRouteable {
///     override func registerRouteables() {
///         register(AppIntentRouteable.self)
///         register(AppURLRouteable.self)
///     }
/// }
/// ```
///
/// For more complex scenarios that require more granular control, your app may also register a closure that is invoked
/// by this routeable to adapt the inbound `NSUserActivity` into a `Routeable`:
///
/// ```
/// class AppUserActivityRouteable: UserActivityRouteable {
///     override func registerRouteables() {
///         register { (activity: NSUserActivity) -> AnyRouteable? in
///             let routeable = // ... decode the activity
///             return routeable.eraseToAnyRouteable()
///         }
///     }
/// }
/// ```
@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
open class UserActivityRouteable {
    
    private let userActivity: NSUserActivity
    private var decoders = [ActivityDecoder]()
    
    /// Initializes a routeable backed by the specified user activity.
    /// - Parameter userActivity: An `NSUserActivity` that describes the content to route to.
    public init(userActivity: NSUserActivity) {
        self.userActivity = userActivity
        registerRouteables()
    }
    
    /// Provides a convenient hook for subclasses to register their `Routeable` types for later instantiation.
    open func registerRouteables() {
        
    }
    
    /// Registers a decoding function that yields a routeable from an activity.
    /// - Parameter decoder: A block that will be used to decode the incoming user activity. This block should return
    ///                      the type erased routeable represented by the activity, or `nil` if a routeable cannot be
    ///                      decoded from the activity.
    public func register(decoder: @escaping (NSUserActivity) -> AnyRouteable?) {
        decoders.append(ActivityDecoder(decoder))
    }
    
}

// MARK: - Decoding of NSUserActivity types

@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
extension UserActivityRouteable {
    
    private struct ActivityDecoder {
        
        private let _decode: (NSUserActivity) -> AnyRouteable?
        
        init(_ block: @escaping (NSUserActivity) -> AnyRouteable?) {
            _decode = block
        }
        
        func decode(userActivity: NSUserActivity) -> AnyRouteable? {
            _decode(userActivity)
        }
        
    }
    
}

// MARK: - UserActivityRouteable + Routeable

@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
extension UserActivityRouteable: Routeable {
    
    public static func == (lhs: UserActivityRouteable, rhs: UserActivityRouteable) -> Bool {
        lhs.userActivity === rhs.userActivity
    }
    
}

// MARK: - UserActivityRouteable + YieldsRoutable

@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
extension UserActivityRouteable: YieldsRoutable {
    
    public func yield(to recipient: YieldedRouteableRecipient) {
        for decoder in decoders {
            if let routeable = decoder.decode(userActivity: userActivity) {
                routeable.yield(to: recipient)
                break
            }
        }
    }
    
}
