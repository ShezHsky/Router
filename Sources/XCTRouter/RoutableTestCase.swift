import RouterCore
import XCTest

/// Base test case for `Routeable`s for common assertions.
open class RouteableTestCase: XCTestCase {
    
    /// Asserts a `Routeable` correctly yields another `Routeable`.
    ///
    /// - Parameters:
    ///   - content: The `Routeable` that is expected to yield `expected`
    ///   - expected: The `Routeable` that is expected to be yielded by `content`.
    public func assert<T, U>(
        content: T,
        isDescribedAs expected: U,
        file: StaticString = #file,
        line: UInt = #line
    ) where T: Routeable, U: Routeable {
        let recipient = CapturingRouteableRecipient()
        content.recursivleyYield(to: recipient)
        
        XCTAssertEqual(
            expected.eraseToAnyRouteable(),
            recipient.erasedRoutedContent,
            file: file,
            line: line
        )
    }
    
    /// Asserts `Routeable` does not yield another `Routeable`.
    /// - Parameters:
    ///   - content: The `Routeable` that is not expected to yield another `Routeable`.
    public func assertNoDescription<T>(
        content: T,
        file: StaticString = #file,
        line: UInt = #line
    ) where T: YieldsRoutable {
        let recipient = CapturingRouteableRecipient()
        content.yield(to: recipient)
        
        XCTAssertNil(
            recipient.erasedRoutedContent,
            file: file,
            line: line
        )
    }
    
}
