#if canImport(Intents)

import Intents

/// A type that can be initialized using an `INIntent`.
@available(iOS 10.0, *, macOS 11.0, *, watchOS 3.2, *, tvOS 14.0, *)
public protocol ExpressibleByIntent {
    
    /// The specific type of `INIntent` this type can be initialized with.
    associatedtype Intent: INIntent
    
    /// Creates an instance initialized to the given `Intent` value.
    /// - Parameter intent: The value of the new instance.
    init(intent: Intent)
    
}

#endif
