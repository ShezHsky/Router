import RouterCore

struct WellKnownContent: Routeable {
    
}

struct SomeOtherWellKnownContent: Routeable {
    
}

struct WrapperContent<Content>: Routeable, YieldsRoutable
    where Content: Routeable {
    
    var inner: Content
    
    func yield(to recipient: YieldedRouteableRecipient) {
        recipient.receive(inner)
    }
    
}

class WellKnownContentRoute: Route {
    
    typealias Content = WellKnownContent
    
    private(set) var routedContent: WellKnownContent?
    func route(_ content: WellKnownContent) {
        routedContent = content
    }
    
}

class SomeOtherWellKnownContentRoute: Route {
    
    typealias Content = SomeOtherWellKnownContent
    
    private(set) var routedContent: SomeOtherWellKnownContent?
    func route(_ content: SomeOtherWellKnownContent) {
        routedContent = content
    }
    
}

struct TemplatedRouteable<T>: Routeable where T: Equatable {
    
    var value: T
    
}

class TemplatedRoute<T>: Route where T: Routeable {
    
    typealias Parameter = T
    
    private(set) var routed: T?
    func route(_ parameter: T) {
        routed = parameter
    }
    
}

struct WellKnownContentRouteProvider: RouteProvider {
    
    private let subRoute: RouteableDispatching
    
    init(subRoute: RouteableDispatching) {
        self.subRoute = subRoute
    }
    
    var routes: Routes {
        Routes {
            subRoute
        }
    }
    
}
