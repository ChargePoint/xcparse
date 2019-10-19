// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xcparse",
    platforms: [
       .macOS(.v10_13),
    ],
    products: [
        .executable(name: "xcparse", targets: ["xcparse"]),
        .library(
            name: "XCParseCore",
            targets: ["XCParseCore"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-package-manager.git", .exact("0.5.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "xcparse",
            dependencies: [ "XCParseCore", "SPMUtility" ]),
        .target(
            name: "XCParseCore",
            dependencies: [ "SPMUtility" ]),
        .testTarget(
            name: "xcparseTests",
            dependencies: ["xcparse"]),
    ],
    swiftLanguageVersions: [.v5]
)
