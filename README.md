![Aptabase](https://aptabase.com/og.png)

# Swift SDK for Aptabase

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Faptabase%2Faptabase-swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/aptabase/aptabase-swift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Faptabase%2Faptabase-swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/aptabase/aptabase-swift)


Instrument your apps with Aptabase, an Open Source, Privacy-First and Simple Analytics for Mobile, Desktop and Web Apps.

## Install

#### Option 1: Swift Package Manager

Add the following lines to your `Package.swift` file:

```swift
let package = Package(
    ...
    dependencies: [
        ...
        .package(name: "Aptabase", url: "https://github.com/aptabase/aptabase-swift.git", branch: "main"), // Add the package
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["Aptabase"] // Add as a dependency
        )
    ]
)
```

#### Option 2: Adding package dependencies with Xcode

Use this [guide](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) to add `aptabase-swift` to your project. Use https://github.com/aptabase/aptabase-swift for the url when Xcode asks.

## Usage

First you need to get your `App Key` from Aptabase, you can find it in the `Instructions` menu on the left side menu.

Initialized the SDK as early as possible in your app, for example:

```swift
import SwiftUI
import Aptabase

@main
struct ExampleApp: App {
    init() {
        Aptabase.shared.initialize(appKey: "<YOUR_APP_KEY>") // 👈 this is where you enter your App Key
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
```

Afterwards you can start tracking events with `trackEvent`:

```swift
import Aptabase

Aptabase.shared.trackEvent("connect_click") // An event with no properties
Aptabase.shared.trackEvent("play_music", with: ["name": "Here comes the sun"]) // An event with a custom property
```

A few important notes:

1. The SDK will automatically enhance the event with some useful information, like the OS, the app version, and other things.
2. You're in control of what gets sent to Aptabase. This SDK does not automatically track any events, you need to call `trackEvent` manually.
   - Because of this, it's generally recommended to at least track an event at startup
3. The `trackEvent` function is a non-blocking operation as it runs on the background.
4. Only strings and numbers values are allowed on custom properties
