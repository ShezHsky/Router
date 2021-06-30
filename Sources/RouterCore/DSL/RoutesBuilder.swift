/// A result builder used to formulate the routing DSL.
///
/// The router DSL provides a straightforward way to construct the routing system of your app in a more developer
/// friendly manner. Consider the following block of imperative route-assembling code:
/// ```
/// var routes = Routes()
/// routes.install(EventRoute())
///
/// var newsSubdomain = Routes()
/// newsSubdomain.install(NewsArticleRoute(router: newsSubdomain))
/// newsSubdomain.install(EventRoute())
///
/// if enableAnnouncementLinks {
///     newsSubdomain.install(AnnouncementRoute())
/// }
///
/// routes.install(newsSubdomain)
/// ```
///
/// This same route assembling code can be expressed in the DSL using the following declarative syntax:
///
/// ```
/// let routes = Routes {
///     EventRoute()
///     Routes { (subrouter) in
///         NewsArticleRoute(router: subrouter)
///         EventRoute()
///
///         if enableAnnouncementLinks {
///             AnnouncementRoute()
///         }
///     }
/// }
/// ```
///
/// You may define your own language as part of the DSL by declaring types that conform to the `RouteProvider` protocol.
///
@resultBuilder public struct RoutesBuilder {
    
    public static func buildBlock(_ components: RouteProvider ...) -> Routes {
        Routes(providers: components)
    }
    
    public static func buildEither(first component: RouteProvider) -> RouteProvider {
        component
    }
    
    public static func buildEither(second component: RouteProvider) -> RouteProvider {
        component
    }
    
}
