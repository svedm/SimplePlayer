// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SSDPClient",
    platforms: [
        .macOS("12.0"),
        .macCatalyst("15.0"),
        .iOS("15.0"),
        .tvOS("15.0"),
        .watchOS("8.0")
    ],
    products: [
        .library(
            name: "SSDPClient",
            targets: ["SSDPClient"]
        ),
    ],
    dependencies: [
         .package(url: "https://github.com/apple/swift-nio", from: "2.29.0"),
         .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
    ],
    targets: [
        .target(
            name: "SSDPClient",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "SSDPClientTests",
            dependencies: ["SSDPClient"]
        ),
    ]
)
