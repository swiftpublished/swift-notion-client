// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import class Foundation.ProcessInfo

let package = Package(
    name: "swift-notion-client",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NotionClient",
            targets: ["NotionClient"]
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NotionClient",
            dependencies: [
                .product(name: "NotionParsing", package: "swift-notion-parsing")
            ],
            path: "Sources/Client"
        ),
        .executableTarget(
            name: "NotionClientExe",
            dependencies: ["NotionClient"],
            path: "Sources/Exe"
        ),
        .testTarget(
            name: "NotionClientTests",
            dependencies: ["NotionClient"],
            path: "Tests/ClientTests"
        )
    ]
)

/// Local Development Setup
/// We can set `CI_ENVIRONMENT` in Github to fetch from Remote
if ProcessInfo.processInfo.environment["CI_ENVIRONMENT"] == "YES" {
    package.dependencies += [
        .package(url: "https://github.com/swiftpublished/swift-notion-parsing", branch: "main")
    ]
} else {
    package.dependencies += [
        .package(path: "../swift-notion-parsing")
    ]
}