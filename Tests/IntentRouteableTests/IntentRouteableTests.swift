#if canImport(Intents)

import IntentRouteable
import Intents
import RouterCore
import XCTest
import XCTRouter

class IntentRouteableTests: XCTestCase {
    
    func testEqualityByIntentInstance() {
        let intent = INIntent()
        let first = TestingIntentRouteable(intent)
        let firstNewInstance = TestingIntentRouteable(intent)
        let second = TestingIntentRouteable(INIntent())
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(firstNewInstance, first)
        XCTAssertNotEqual(first, second)
    }
    
    func testRegisteredTypeDecodesInfoFromIntent() {
        let intent = INIntent()
        let routeable = TestingIntentRouteable(intent)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = InitializedUsingIntent(intent: intent)
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    private class TestingIntentRouteable: IntentRouteable {
        
        override func registerRouteables() {
            super.registerRouteables()
            registerIntent(InitializedUsingIntent.self)
        }
        
    }
    
    private struct InitializedUsingIntent: Routeable, ExpressibleByIntent {
        
        var intent: INIntent
        
        typealias Intent = INIntent
        
        init(intent: Intent) {
            self.intent = intent
        }
        
    }
    
}

#endif
