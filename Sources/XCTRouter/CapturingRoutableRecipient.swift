import RouterCore

public class CapturingRouteableRecipient: YieldedRouteableRecipient {
    
    public init() {
        
    }
    
    public private(set) var erasedRoutedContent: AnyRouteable?
    public func receive<Content>(_ content: Content) where Content: Routeable {
        erasedRoutedContent = content.eraseToAnyRouteable()
    }
    
}
