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
    
    func testSuccessfulDecoding_CustomDecoder() {
        let routeable = CustomDecoderRouteable("Unused, should expect the factory!")
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = CanDecodeFromString(stringValue: "Stub!")
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    private struct FakeDecoder: CanCreateRepresentedRouteable {
        
        typealias Representation = String
        typealias RepresentedRouteable = CanDecodeFromString
        
        var routeable: CanDecodeFromString
        
        func makeRouteable(for representation: String) -> CanDecodeFromString? {
            routeable
        }
        
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
    
    private class CustomDecoderRouteable: ExternallyRepresentedRouteable<String> {
        
        let customDecoder = FakeDecoder(routeable: CanDecodeFromString(stringValue: "Stub!"))
        
        override func registerRouteables() {
            super.registerRouteables()
            
            register(customDecoder)
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
