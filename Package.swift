// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Router",
    defaultLocalization: "en",
    products: [
        // The full Router package
        .library(name: "Router", targets: [
            "RouterCore",
            "SwiftLogRouteLogger",
            "URLRouteable",
            "IntentRouteable",
            "UserActivityRouteable",
            "NotificationRouteable"
        ]),
        
        // Just core routing types and responsibilities
        .library(name: "RouterCore", targets: ["RouterCore"]),
        
        // swift-log RouteLogger implementation
        .library(name: "SwiftLogRouteLogger", targets: ["SwiftLogRouteLogger"]),
        
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
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", .upToNextMajor(from: .init(1, 0, 0))),
        .package(url: "https://github.com/ShezHsky/URLDecoder.git", .upToNextMajor(from: .init(0, 0, 2)))
    ],
    targets: [
        .target(name: "RouterCore", dependencies: []),
        
        .target(name: "SwiftLogRouteLogger", dependencies: [
            .target(name: "RouterCore"),
            .product(name: "Logging", package: "swift-log")
        ]),
        
        .target(name: "URLRouteable", dependencies: [
            .target(name: "RouterCore"),
            .product(name: "URLDecoder", package: "URLDecoder")
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
        
        .testTarget(name: "SwiftLogRouteLoggerTests", dependencies: [
            .target(name: "SwiftLogRouteLogger"),
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
