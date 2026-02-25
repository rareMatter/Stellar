# Stellar

> **Stellar is a work in progress.**

A declarative, cross-platform UI framework for Swift — write once, run everywhere. Inspired by SwiftUI and React.

## Requirements

- Swift 5.5+
- iOS 15+

Planned platform support includes macOS 11+, iPadOS 14+, and watchOS.

## Installation

### Swift Package Manager

Add Stellar to your `Package.swift` dependencies. Because Stellar has not yet published a stable release, reference the `main` branch:

```swift
dependencies: [
    .package(url: "https://github.com/rareMatter/Stellar", branch: "main")
]
```

> Once a stable release is published, prefer specifying a version tag (e.g., `.upToNextMajor(from: "1.0.0")`) over a branch reference.

Then add `"Stellar"` to the `dependencies` array of any target that needs it:

```swift
.target(name: "MyApp", dependencies: ["Stellar"])
```

## Usage

### Defining your app

Conform a type to `SApp` and mark it with `@main` to define the entry point:

```swift
import Stellar

@main
struct MyApp: SApp {
    var window: some SWindow {
        SWindow {
            ContentView()
        }
    }
}
```

### Building views

Conform a type to `SContent` and implement `body` using `@SContentBuilder`:

```swift
import Stellar

struct ContentView: SContent {
    var body: some SContent {
        SVStack {
            SText("Hello, Stellar!")
            SButton(action: { print("tapped") }) {
                SText("Tap me")
            }
        }
    }
}
```

### Managing state

Use `@SState` for local view state and `SBinding` to pass mutable values down the view hierarchy:

```swift
struct CounterView: SContent {
    @SState var count = 0

    var body: some SContent {
        SVStack {
            SText("Count: \(count)")
            SButton(action: { count += 1 }) {
                SText("Increment")
            }
        }
    }
}
```

