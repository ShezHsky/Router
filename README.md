# Router

Describe pathways to content in your app that can be handled in response to user or external actions.

## Overview

Users navigate to parts of your app in order to execute tasks or consume content. These navigation pathways are often repeated as the complexity of your app grows, as users expect to be shown the same content in response to scanning a QR code, NFC tag, Safari deep link, among others.

The Router package provides a Domain Specific Language (DSL) that allows you to express these routes within your app, that are instigated in response to routing specific content markers denoted as `Routeable`s. These markers are typically lightweight value objects that reference an identifier for the destination content. These pathways can then be invoked from anywhere in your app by a `Route`, optionally overriden for particular subdomains.

Defining a route and associated routeable requires only a few lines of code. For instance, in an scheduling app, an `Event` associated with a unique identifier can be represented as a routeable containing the identifier of the event:

```swift
struct EventRouteable: Routeable {
    var id: UUID
}
```

The associated `Route` used to handle this routeable consumes instances of the `EventRouteable` by performing the necessary presentation code in your app. For instance, a UIKit based app may push the corresponding view controller onto a navigation controller:

```swift
struct EventRoute: Route {
    var navigationController: UINavigationController
    
    func route(_ parameter: EventRouteable) {
        navigationController.push(EventDetailViewController(event: parameter.id), animated: true)
    }
}
```

Alternativley, a SwiftUI app may update the corresponding view model for the parent view:

```swift
struct EventRoute: Route {
    var eventsViewModel: EventsViewModel
    
    func route(_ parameter: EventRouteable) {
        eventsViewModel.presentedEvent = parameter.id
    }
}
```

During the setup of your app's scene, the `Route` is registered using the DSL syntax. The returned type conforms to the `Router` protocol, which can be referenced throughout your app in order to execute the route:

```swift
let navigationController = UINavigationController(rootViewController: eventsViewController)
let router = Routes {
    EventRoute(navigationController: navigationController)
}

// ... some time later

try router.route(EventRoute(id: eventIdentifier))
```

## Package Libraries

The router package is split into multiple libraries in order to tailor the integration requirements of your app.

- `Router` - all below libraries
- `RouterCore` - the router DSL and types to support it are available here
- `IntentRouteable` - provides types to map an `INIntent` into a routeable
- `NotificationRouteable` - provides types to map the user info dictionary from a local or remote notification to a routeable
- `URLRouteable` - provides types to map a `URL` representing a deep link into a routeable
- `UserActivityRouteable` - provides types to continue an `NSUserActivity` by adapting its representation into a routeable

The package also vendors products you may import to aid in testing routables within your app:

- `XCTRouter` - assert your code submits expected `Routeable`s to a router, unwrap a complex `Routeable`, and assert against `Routeable`s from your test targets
- `XCTURLRouteable` - assert your custom subclass of `URLRouteable` yields the expected `Routeable`s when fed particular URLs.
