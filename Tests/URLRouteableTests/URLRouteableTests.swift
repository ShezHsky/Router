import RouterCore
import URLDecoder
import URLRouteable
import XCTest
import XCTRouter

class URLRouteableTests: XCTestCase {
    
    func testEqualityByURL() throws {
        let firstUrl = try XCTUnwrap(URL(string: "https://www.google.co.uk"))
        let secondUrl = try XCTUnwrap(URL(string: "https://www.google.co.uk/search?q=Hello"))
        let first = URLRouteable(firstUrl)
        let firstNewInstance = URLRouteable(firstUrl)
        let second = URLRouteable(secondUrl)
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(firstNewInstance, first)
        XCTAssertNotEqual(first, second)
    }
    
    func testTypeThatCreatesItselfFromURL() throws {
        let url = try XCTUnwrap(URL(string: "https://www.google.co.uk"))
        let routeable = TestingURLRouteable(url)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = try XCTUnwrap(CreatesItselfByManuallyDecodingURL(url: url))
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    func testTypeThatParsesTwoComponentsFromURL() throws {
        let url = try XCTUnwrap(URL(string: "https://www.google.co.uk/search?q=Hello&f=1"))
        let routeable = TestingURLRouteable(url)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = CreatesItselfByDecodingGoogleURL(firstCaptureGroup: "Hello", secondCaptureGroup: 1)
        
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    func testUnknownURLVendorsUnsupportedRouteable() throws {
        let url = try XCTUnwrap(URL(string: "https://www.google.co.uk/some_feature_we_have_no_decoder_for"))
        let routeable = URLRouteable(url)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = UnknownURLRouteable(url: url)
        
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    func testUsingCustomDecoder() throws {
        let url = try XCTUnwrap(URL(string: "https://www.yahoo.co.uk/search?q=Hello&f=1"))
        let routeable = TestingURLRouteable(url)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = CreatesItselfByDecodingYahooURL(firstCaptureGroup: "Hello", secondCaptureGroup: 1)
        
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    private class TestingURLRouteable: URLRouteable {
        
        override func registerRouteables() {
            super.registerRouteables()
            
            registerURL(CreatesItselfByDecodingGoogleURL.self, decoder: {
                var decoder = URLDecoder()
                decoder.urlCriteria.host = .matches("www.google.co.uk")
                
                return decoder
            }())
            
            registerURL(CreatesItselfByDecodingYahooURL.self)
            registerURL(CreatesItselfByManuallyDecodingURL.self)
        }
        
    }
    
    private struct CreatesItselfByManuallyDecodingURL: Routeable, ExpressibleByURL {
        
        var url: URL
        
        init?(url: URL) {
            self.url = url
        }
        
    }
    
    private struct CreatesItselfByDecodingGoogleURL: Decodable, Routeable {
        
        private enum CodingKeys: String, CodingKey {
            case firstCaptureGroup = "q"
            case secondCaptureGroup = "f"
        }
        
        var firstCaptureGroup: String
        var secondCaptureGroup: Int
        
        init(firstCaptureGroup: String, secondCaptureGroup: Int) {
            self.firstCaptureGroup = firstCaptureGroup
            self.secondCaptureGroup = secondCaptureGroup
        }
        
    }
    
    private struct CreatesItselfByDecodingYahooURL: Decodable, Routeable {
        
        private enum CodingKeys: String, CodingKey {
            case firstCaptureGroup = "q"
            case secondCaptureGroup = "f"
        }
        
        var firstCaptureGroup: String
        var secondCaptureGroup: Int
        
        init(firstCaptureGroup: String, secondCaptureGroup: Int) {
            self.firstCaptureGroup = firstCaptureGroup
            self.secondCaptureGroup = secondCaptureGroup
        }
        
    }
    
}
