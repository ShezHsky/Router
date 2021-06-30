/// A collection of `Route`s that is used to dispatch `Routeable`s.
///
/// The `Routes` type is typically used at the root of the routing DSL, enabling a complex routing arrangement within
/// your app to be declared in a few lined of code.
///
/// The following example demonstrates mixing a single top-level route alongside a subdomain of related routes, in which
/// the top level route is overridden for that subdomain:
///
/// ```
/// let routes = Routes {
///     EventRoute()
///     Routes { (subrouter) in
///         NewsArticleRoute(router: subrouter)
///         EventRoute()
///     }
/// }
/// ```
///
/// - Important:
/// The set of available routes available in each instance should be scoped to the execution context of a single scene
/// or window. For example, in an iPad app that supports multiple scenes each scene should have its own collection of
/// routes. That way, navigating within the scene instigates the route associated with it - rather than navigating to
/// content in another scene.
///
/// - Note:
/// Your app should reference the return type of the DSL, and other held references to this type, as the `Router` type.
/// This makes it easier to test invocations of the router from inside your app by substituting the collection of
/// routes with a test double.
public struct Routes {
    
    private var dispatchers: [RouteableDispatching]
    
    /// Initializes an empty set of `Routes`.
    public init() {
        dispatchers = []
    }
    
    /// Initializes a set of `Routes` defined by the DSL block.
    /// - Parameter builder: A block formed using the DSL function builder that generates a set of routes to define
    ///                      this instance.
    public init(@RoutesBuilder builder: () -> Routes) {
        dispatchers = builder().dispatchers
    }
    
    /// Initializes a set of `Routes` defined by the DSL block, providing the subrouter for the block.
    ///
    /// Your app may want to override a top level route for a subdomain of your user interface (e.g. presenting content
    /// in a panel rather than using progressive disclosure). Using the `Router` provided to the DSL block enables the
    /// route in the subdomain to supercede the route in another.
    ///
    /// - Parameter builder: A block formed using the DSL function builder that generates a set of routes to define
    ///                      this instance. The block takes one `Router` argument that enables superceding routes
    ///                      declared earlier in the DSL with ones in the subdomain being declared.
    public init(@RoutesBuilder builder: (Router) -> Routes) {
        class SubrouterProxy: Router {
            
            var target: Router?
            
            func route<R>(_ content: R) throws where R: Routeable {
                try target?.route(content)
            }

        }
        
        let proxy = SubrouterProxy()
        dispatchers = builder(proxy).dispatchers
        proxy.target = self
    }
    
    init(children: [RouteableDispatching]) {
        self.dispatchers = children
    }
    
    init(providers: [RouteProvider]) {
        dispatchers = []
        
        for routes in providers.map(\.routes) {
            dispatchers.append(contentsOf: routes.dispatchers)
        }
    }
    
    /// Appends a dispatcher to this collection of `Route`s.
    ///
    /// Your app may use this function in preference to the DSL. The same features are available as in the DSL:
    ///
    /// - Individual `Route`s can be registered to act as top level routes.
    /// - A collection of `Routes` can be registered to act as a subdomain of routes.
    ///
    /// - Parameter route: The `RouteableDispatching` type to register within this set of `Route`s.
    public mutating func install(_ route: RouteableDispatching) {
        dispatchers.append(route)
    }
    
    /// Appends the provided collection of `Routes` to this set of `Routes`.
    ///
    /// - Parameter provider: A type conforming to the `RouteProvider` protocol that supplies the `Routes` to append
    ///                       to this set of `Routes`.
    public mutating func install(_ provider: RouteProvider) {
        install(provider.routes)
    }
    
}

// MARK: - Routes + Router

extension Routes: Router {
    
    public func route<R>(_ content: R) throws where R: Routeable {
        let executor = ExecuteRoute(dispatchers: dispatchers)
        content.recursivleyYield(to: executor)
        
        if let error = executor.error {
            throw error
        }
    }
    
    private class ExecuteRoute: YieldedRouteableRecipient {
        
        private let dispatchers: [RouteableDispatching]
        private(set) var error: Error?
        
        init(dispatchers: [RouteableDispatching]) {
            self.dispatchers = dispatchers
        }
        
        func receive<Content>(_ content: Content) where Content: Routeable {
            var result: RouteDispatchResult = .notDispatched
            let dispatchersInLastAddedOrder = dispatchers.reversed()
            
            for dispatcher in dispatchersInLastAddedOrder {
                if dispatcher.dispatch(routable: content) == .dispatched {
                    result = .dispatched
                    break
                }
            }
            
            if result == .notDispatched {
                error = RouteMissing(content: content)
            }
        }
        
    }
    
}

// MARK: - Routes + RouteProvider

extension Routes: RouteProvider {
    
    public var routes: Routes {
        self
    }
    
}

// MARK: - Routes + Route

extension Routes: RouteableDispatching {
    
    public func dispatch<R>(routable: R) -> RouteDispatchResult where R: Routeable {
        do {
            try route(routable)
            return .dispatched
        } catch {
            return .notDispatched
        }
    }
    
}
