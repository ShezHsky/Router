/// A type that can produce `Routeable`s from an external representation.
public protocol CanCreateRepresentedRouteable {
    
    /// The external representation that can be used to initialize instances of the `RepresentedRouteable` type.
    associatedtype Representation
    
    /// The type of `Routeable` this factory can produce.
    associatedtype RepresentedRouteable: Routeable
    
    /// Attempts to create an instance of the `RepresentedRouteable` initialized to the given `Representation` value.
    /// - Parameter representation: The value of the new instance.
    /// - Returns: An instance of the initialized `RepresentedRouteable`, or `nil` if the initialization failed.
    func makeRouteable(for representation: Representation) -> RepresentedRouteable?
    
}
