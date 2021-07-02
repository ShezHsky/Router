import IntentRouteable
import Intents
import RouterCore
import URLRouteable
import UserActivityRouteable
import XCTest
import XCTRouter

class UserActivityRouteableTests: XCTestCase {
    
    func testEqualityByActivityInstance() {
        let userActivity = NSUserActivity(activityType: "uk.co.Router.Test")
        let first = TestingUserActivityRouteable(userActivity: userActivity)
        let firstNewInstance = TestingUserActivityRouteable(userActivity: userActivity)
        let second = TestingUserActivityRouteable(userActivity: NSUserActivity(activityType: "uk.co.Router.Test"))
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(firstNewInstance, first)
        XCTAssertNotEqual(first, second)
    }
    
    func testBackedByKnownURL() throws {
        let url = try XCTUnwrap(URL(string: "https://www.google.co.uk"))
        let userActivity = NSUserActivity(activityType: "uk.co.Router.Test")
        userActivity.webpageURL = url
        let routeable = TestingUserActivityRouteable(userActivity: userActivity)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = CreatesItselfFromAnyURL(representitiveValue: url)
        XCTAssertEqual(expected?.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
#if !os(macOS)
    
    func testBackedByKnownIntent() throws {
        let intent = INIntent()
        let interaction = INInteraction(intent: intent, response: nil)
        let userActivity = FakeActivityForStubbingInteractions(activityType: "uk.co.Router.Test")
        userActivity.stubbedInteraction = interaction
        let routeable = TestingUserActivityRouteable(userActivity: userActivity)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = InitializedUsingIntent(intent: intent)
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    func testBackedByURLAndIntent_FirstRegisteredWins() throws {
        let url = try XCTUnwrap(URL(string: "https://www.google.co.uk"))
        let intent = INIntent()
        let interaction = INInteraction(intent: intent, response: nil)
        let userActivity = FakeActivityForStubbingInteractions(activityType: "uk.co.Router.Test")
        userActivity.webpageURL = url
        userActivity.stubbedInteraction = interaction
        let routeable = TestingUserActivityRouteable(userActivity: userActivity)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = CreatesItselfFromAnyURL(representitiveValue: url)
        XCTAssertEqual(expected?.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
#endif
    
    private class FakeActivityForStubbingInteractions: NSUserActivity {
        
        var stubbedInteraction: INInteraction?
        
#if !os(macOS)
        override var interaction: INInteraction? {
            stubbedInteraction
        }
#endif
        
    }
    
    private class TestingUserActivityRouteable: UserActivityRouteable {
        
        override func registerRouteables() {
            super.registerRouteables()
            
            register(TestingURLRouteable.self)
            
#if !os(macOS)
            register(TestingIntentRouteable.self)
#endif
        }
        
    }
    
    private class TestingURLRouteable: URLRouteable {
        
        override func registerRouteables() {
            super.registerRouteables()
            
            register(CreatesItselfFromAnyURL.self)
        }
        
    }
    
    private struct CreatesItselfFromAnyURL: Routeable, ExpressibleByExternalRepresentation {
        
        var url: URL
        
        init?(representitiveValue: URL) {
            self.url = representitiveValue
        }
        
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
