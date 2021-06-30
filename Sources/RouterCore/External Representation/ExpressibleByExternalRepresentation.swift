/// A type that can be initialized using an external representation.
public protocol ExpressibleByExternalRepresentation {
    
    /// The external representation that can be used to initialize instances of this type.
    associatedtype Representation
    
    /// Creates an instance initialized to the given `Representation` value.
    /// - Parameter representitiveValue: The value of the new instance.
    init?(representitiveValue: Representation)
    
}
