import RouterCore
import XCTest

/// A `Router` that provides common assertions for types that collaborate with `Router`s.
public class FakeContentRouter: Router {
    
    public init() {
        
    }
    
    public private(set) var erasedRoutedContent: AnyRouteable?
    public func route<R>(_ content: R) throws where R: Routeable {
        erasedRoutedContent = content.eraseToAnyRouteable()
    }
    
    /// Asserts a given `Routeable` has been routed to using this `Router`.
    /// - Parameters:
    ///   - expected: The `Routeable` that should have been routed to this `Router`.
    public func assertRouted<Content>(
        to expected: Content,
        file: StaticString = #file,
        line: UInt = #line
    ) where Content: Routeable {
        XCTAssertEqual(
            expected.eraseToAnyRouteable(),
            erasedRoutedContent,
            file: file,
            line: line
        )
    }
    
    /// Asserts a given `Routeable` has not been routed to using this `Router`.
    /// - Parameters:
    ///   - expected: The `Routeable` that should not have been routed to this `Router`.
    public func assertDidNotRoute<Content>(
        to unexpected: Content,
        file: StaticString = #file,
        line: UInt = #line
    ) where Content: Routeable {
        XCTAssertNotEqual(
            unexpected.eraseToAnyRouteable(),
            erasedRoutedContent,
            file: file,
            line: line
        )
    }
    
    /// Attempts to unwrap the last routed `Routeable` from the erased type.
    /// - Parameters:
    ///   - targetType: The destination `Routeable` type to attempt an unwrap from.
    /// - Throws: If the erased `Routeable` cannot be unwrapped into the `Target` type.
    /// - Returns: An instance of the last routed `Routeable` typed as the `Target` type.
    public func unwrapRoutedContent<Target>(
        into targetType: Target.Type = Target.self,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Target where Target: Routeable {
        let unwrapper: Unwrapper<Target> = Unwrapper()
        erasedRoutedContent?.yield(to: unwrapper)
        
        return try XCTUnwrap(unwrapper.unwrapped, file: file, line: line)
    }
    
    private class Unwrapper<Target>: YieldedRouteableRecipient where Target: Routeable {
        
        var unwrapped: Target?
        
        func receive<Content>(_ content: Content) where Content: Routeable {
            unwrapped = content as? Target
        }
        
    }
    
}
