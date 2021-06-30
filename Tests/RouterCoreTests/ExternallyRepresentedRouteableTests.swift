import RouterCore
import XCTest
import XCTRouter

class ExternallyRepresentedRouteableTests: XCTestCase {
    
    func testSuccessfulDecoding_OneDecoder() {
        let routeable = OneDecoderRouteable("Hello, world")
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = CanDecodeFromString(stringValue: "Hello, world")
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    func testSuccessfulDecoding_TwoDecoders_FirstRegisteredWins() {
        let routeable = TwoDecodersRouteable("Hello, world")
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = CanDecodeFromString(stringValue: "Hello, world")
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    private class OneDecoderRouteable: ExternallyRepresentedRouteable<String> {
        
        override func registerRouteables() {
            super.registerRouteables()
            
            register(CanDecodeFromString.self)
        }
        
    }
    
    private class TwoDecodersRouteable: ExternallyRepresentedRouteable<String> {
        
        override func registerRouteables() {
            super.registerRouteables()
            
            register(CanDecodeFromString.self)
            register(CanAlsoDecodeFromString.self)
        }
        
    }
    
    private struct CanDecodeFromString: Routeable, ExpressibleByExternalRepresentation {
        
        var stringValue: String?
        
        init(stringValue: String?) {
            self.stringValue = stringValue
        }
        
        init?(representitiveValue: String) {
            stringValue = representitiveValue
        }
        
    }
    
    private struct CanAlsoDecodeFromString: Routeable, ExpressibleByExternalRepresentation {
        
        var stringValue: String?
        
        init(stringValue: String?) {
            self.stringValue = stringValue
        }
        
        init?(representitiveValue: String) {
            stringValue = representitiveValue
        }
        
    }
    
}
