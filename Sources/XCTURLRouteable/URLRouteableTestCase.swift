import RouterCore
import URLRouteable
import XCTest
import XCTRouter

/// Base test case for `URLRouteable`s for common assertions.
open class URLRouteableTestCase: RouteableTestCase {
    
    /// Asserts an app's custom `URLRouteable` yields an expected routerable from a URL.
    /// - Parameters:
    ///   - urlString: A string representation of a content URL.
    ///   - type: The type of `URLRouteable` declared by the app to support routing to URL compatible content.
    ///   - expected: The expected `Routeable` to be yielded from the URL.
    public func assertURL<T, U>(
        _ urlString: String,
        routedVia type: T.Type,
        isDescribedAs expected: U,
        file: StaticString = #file,
        line: UInt = #line
    ) throws where T: URLRouteable, U: Routeable {
        let url = try XCTUnwrap(URL(string: urlString), file: file, line: line)
        let urlRouteable = T(url)
        
        assert(content: urlRouteable, isDescribedAs: expected, file: file, line: line)
    }
    
}
