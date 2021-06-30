/// A type that acts as the source of one or more `Route`s.
///
/// The `RouteProvider` is the backbone of the routing DSL. The `Routes` it provides may itself contain further
/// providers, forming a complex routing graph out of simple building blocks.
public protocol RouteProvider {
    
    /// A collection of one or more `Route`s.
    ///
    /// Implementations of this protocol should return a collection of `Routes` that support the formation of the DSL
    /// in a developer-friendly manner. The Router package supports a few out the box, including:
    ///
    /// - Any `RouteableDispatching` provides itself as a collection-of-one, allowing mixing top level routes with
    ///   collections in the DSL.
    /// - The `Routes` collection type returns itself as the instance, allowing a subdomain of routes to be defined.
    ///
    /// - Note:
    /// The provided `Route`s should be stateless, as they may be generated multiple times during the lifetime of your
    /// app.
    var routes: Routes { get }
    
}
