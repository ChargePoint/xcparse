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
        ),
        .library(
            name: "Converter",
            targets: ["Converter"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .exact("0.2.4")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "xcparse",
            dependencies: [ "XCParseCore", "SwiftToolsSupport-auto", "Converter" ]),
        .target(
            name: "XCParseCore",
            dependencies: [ "SwiftToolsSupport-auto" ]),
        .target(
            name: "Converter",
            dependencies: ["XCParseCore"]),
        .target(
            name: "testUtility",
            dependencies: [],
            path: "Tests/Utility"),
        .testTarget(
            name: "xcparseTests",
            dependencies: ["xcparse", "testUtility"]),
        .testTarget(
            name: "appThinningConverterTests",
            dependencies: ["Converter", "testUtility"]),
    ],
    swiftLanguageVersions: [.v5]
)
