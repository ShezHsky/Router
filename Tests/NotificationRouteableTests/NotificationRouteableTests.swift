import NotificationRouteable
import RouterCore
import XCTest
import XCTRouter

class NotificationRouteableTests: XCTestCase {
    
    func testInitializingRouteableWithSpecificKeyAndValue_FirstDecodedRouteableIsYielded() {
        let notificationPayload: [AnyHashable: Any] = [
            "key": "value"
        ]
        
        let routeable = TestingNotificationRouteable(notificationPayload)
        let recipient = CapturingRouteableRecipient()
        routeable.recursivleyYield(to: recipient)
        
        let expected = KeyAndValueRouteable(value: "value")
        XCTAssertEqual(expected.eraseToAnyRouteable(), recipient.erasedRoutedContent)
    }
    
    func testEqualityByPayload() {
        let first = TestingNotificationRouteable(["key": "value"])
        let firstNewInstance = TestingNotificationRouteable(["key": "value"])
        let second = TestingNotificationRouteable(["key1": "value1"])
        
        XCTAssertEqual(first, first)
        XCTAssertEqual(first, firstNewInstance)
        XCTAssertNotEqual(first, second)
        XCTAssertNotEqual(firstNewInstance, second)
    }
    
    private class TestingNotificationRouteable: NotificationRouteable {
        
        override func registerRouteables() {
            super.registerRouteables()
            
            registerNotification(KeyAndValueRouteable.self)
            registerNotification(AlsoLooksForKeyAndValueRouteable.self)
        }
        
    }
    
    private struct KeyAndValueRouteable: Routeable, ExpressibleByNotificationPayload {
        
        var value: String?
        
        init(value: String?) {
            self.value = value
        }
        
        init?(notificationPayload: [AnyHashable: Any]) {
            value = notificationPayload["key"] as? String
        }
        
    }
    
    private struct AlsoLooksForKeyAndValueRouteable: Routeable, ExpressibleByNotificationPayload {
        
        var value: String?
        
        init(value: String?) {
            self.value = value
        }
        
        init?(notificationPayload: [AnyHashable : Any]) {
            value = notificationPayload["key"] as? String
        }
        
    }
    
}
