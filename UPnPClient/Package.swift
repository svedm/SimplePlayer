// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UPnPClient",
    platforms: [
        .macOS("12.0"),
        .macCatalyst("15.0"),
        .iOS("15.0"),
        .tvOS("15.0"),
        .watchOS("8.0")
    ],
    products: [
        .library(
            name: "UPnPClient",
            targets: ["UPnPClient"]
        )
    ],
    dependencies: [
        .package(name: "SSDPClient", path: "../SSDPClient"),
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.13.1")
    ],
    targets: [
        .target(
            name: "UPnPClient",
            dependencies: [
                "SSDPClient",
                "XMLCoder"
            ]
        ),
        .testTarget(
            name: "UPnPClientTests",
            dependencies: ["UPnPClient"]
        )
    ]
)
