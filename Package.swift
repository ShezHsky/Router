// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Router",
    defaultLocalization: "en",
    platforms: [.iOS(.v10), .macOS(.v11), .watchOS(.v4), .tvOS(.v14)],
    products: [
        // The full Router package
        .library(name: "Router", targets: [
            "RouterCore",
            "URLRouteable",
            "IntentRouteable",
            "UserActivityRouteable",
            "NotificationRouteable"
        ]),
        
        // Just core routing types and responsibilities
        .library(name: "RouterCore", targets: ["RouterCore"]),
        
        // Interpolation of URLs into Routeables
        .library(name: "URLRouteable", targets: ["URLRouteable"]),
        
        // Conversion of INIntent types into Routeables
        .library(name: "IntentRouteable", targets: ["IntentRouteable"]),
        
        // Handling of NSUserActivity types into Routeables
        .library(name: "UserActivityRouteable", targets: ["UserActivityRouteable"]),
        
        // Handling of notification user info keys and values into Routeables
        .library(name: "NotificationRouteable", targets: ["NotificationRouteable"]),
        
        // Testing support integrating routers into clients
        .library(name: "XCTRouter", targets: ["XCTRouter"]),
        
        // Testing support for URLRouteables
        .library(name: "XCTURLRouteable", targets: ["XCTURLRouteable"])
    ],
    dependencies: [],
    targets: [
        .target(name: "RouterCore", dependencies: []),
        
        .target(name: "URLRouteable", dependencies: [
            .target(name: "RouterCore")
        ]),
        
        .target(name: "IntentRouteable", dependencies: [
            .target(name: "RouterCore")
        ]),
        
        .target(name: "UserActivityRouteable", dependencies: [
            .target(name: "RouterCore"),
            .target(name: "URLRouteable"),
            .target(name: "IntentRouteable")
        ]),
        
        .target(name: "NotificationRouteable", dependencies: [
            .target(name: "RouterCore")
        ]),
        
        .target(name: "XCTRouter", dependencies: [
            .target(name: "RouterCore")
        ]),
        
        .target(name: "XCTURLRouteable", dependencies: [
            .target(name: "URLRouteable"),
            .target(name: "XCTRouter")
        ]),
        
        .testTarget(name: "RouterCoreTests", dependencies: [
            .target(name: "RouterCore"),
            .target(name: "XCTRouter")
        ]),
        
        .testTarget(name: "URLRouteableTests", dependencies: [
            .target(name: "URLRouteable"),
            .target(name: "XCTRouter")
        ]),
        
        .testTarget(name: "IntentRouteableTests", dependencies: [
            .target(name: "IntentRouteable"),
            .target(name: "XCTRouter")
        ]),
        
        .testTarget(name: "UserActivityRouteableTests", dependencies: [
            .target(name: "UserActivityRouteable"),
            .target(name: "XCTRouter")
        ]),
        
        .testTarget(name: "NotificationRouteableTests", dependencies: [
            .target(name: "NotificationRouteable"),
            .target(name: "XCTRouter")
        ])
    ]
)
