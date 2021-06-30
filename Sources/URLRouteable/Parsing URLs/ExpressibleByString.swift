/// A type that can be initialized using a `String`.
public protocol ExpressibleByString {
    
    /// Creates an instance initialized to the given `String` value.
    /// - Parameter stringValue: The value of the new instance.
    init?(stringValue: String)
    
}

// MARK: - String + ExpressibleByString

extension String: ExpressibleByString {
    
    public init?(stringValue: String) {
        self.init(stringValue)
    }
    
}

// MARK: - Int + ExpressibleByString

extension Int: ExpressibleByString {
    
    public init?(stringValue: String) {
        self.init(stringValue)
    }
    
}
