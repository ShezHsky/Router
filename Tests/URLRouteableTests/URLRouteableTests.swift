import RouterCore
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
        
        let expected = try XCTUnwrap(CreatesItselfFromAnyURL(url: url))
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    func testTypeThatParsesOneComponentFromURL() throws {
        let url = try XCTUnwrap(URL(string: "https://www.google.co.uk/search?q=Hello"))
        let routeable = TestingURLRouteable(url)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = CreatesItselfUsingOneParameterFromURL(context: "Hello")
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    func testTypeThatParsesTwoComponentsFromURL() throws {
        let url = try XCTUnwrap(URL(string: "https://www.google.co.uk/search?q=Hello&f=1"))
        let routeable = TestingURLRouteable(url)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = CreatesItselfUsingTwoParametersFromURL(context: ("Hello", 1))
        
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
    
    private class TestingURLRouteable: URLRouteable {
        
        override func registerRouteables() {
            super.registerRouteables()
            
            registerURL(CreatesItselfUsingTwoParametersFromURL.self)
            registerURL(CreatesItselfUsingOneParameterFromURL.self)
            registerURL(CreatesItselfFromAnyURL.self)
        }
        
    }
    
    private struct CreatesItselfFromAnyURL: Routeable, ExpressibleByURL {
        
        var url: URL
        
        init?(url: URL) {
            self.url = url
        }
        
    }
    
    private struct CreatesItselfUsingOneParameterFromURL: Routeable, DecodableFromURL {
        
        typealias ComponentsDecoder = URLDecoder.RegularExpression.OneCaptureGroup<String>
        
        static var decoder: ComponentsDecoder {
            do {
                let regex = try NSRegularExpression(pattern: #"search\?q=(.*)"#, options: [.caseInsensitive])
                return .init(regularExpression: regex)
            } catch {
                fatalError("Invalid regex")
            }
        }
        
        var context: String
        
        init(context: String) {
            self.context = context
        }
        
    }
    
    private struct CreatesItselfUsingTwoParametersFromURL: Routeable, DecodableFromURL {
        
        typealias ComponentsDecoder = URLDecoder.RegularExpression.TwoCaptureGroups<String, Int>
        
        static var decoder: ComponentsDecoder {
            do {
                let regex = try NSRegularExpression(pattern: #"search\?q=(.*)&f=(.*)"#, options: [.caseInsensitive])
                return .init(regularExpression: regex)
            } catch {
                fatalError("Invalid regex")
            }
        }
        
        var firstCaptureGroup: String
        var secondCaptureGroup: Int
        
        init(context: (String, Int)) {
            firstCaptureGroup = context.0
            secondCaptureGroup = context.1
        }
        
    }
    
}
