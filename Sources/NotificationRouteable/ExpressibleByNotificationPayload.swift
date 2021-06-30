/// A type that can be initialized using the contents of a notifications user info dictionary.
public protocol ExpressibleByNotificationPayload {
    
    /// Creates an instance initialized to the given user info payload.
    /// - Parameter notificationPayload: The value of the new instance.
    init?(notificationPayload: NotificationPayload)
    
}
