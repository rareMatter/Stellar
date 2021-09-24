// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stellar",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Stellar",
            targets: ["Stellar"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/malcommac/SwiftDate.git", from: "6.1.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Stellar",
            dependencies: ["SwiftDate", "SnapKit"]),
        .testTarget(
            name: "StellarTests",
            dependencies: ["Stellar"]),
    ]
)
