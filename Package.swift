// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "RudderAppCenter",
    platforms: [
        .iOS("13.0"), .tvOS("11.0"), .macOS("10.13")
    ],
    products: [
        .library(
            name: "RudderAppCenter",
            targets: ["RudderAppCenter"]
        )
    ],
    dependencies: [
        .package(name: "AppCenter", url: "https://github.com/microsoft/appcenter-sdk-apple", "4.4.1"..<"4.4.2"),
        .package(name: "Rudder", url: "https://github.com/rudderlabs/rudder-sdk-ios", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "RudderAppCenter",
            dependencies: [
                .product(name: "AppCenterAnalytics", package: "AppCenter"),
                .product(name: "AppCenterCrashes", package: "AppCenter"),
                .product(name: "Rudder", package: "Rudder"),
            ],
            path: "Sources",
            sources: ["Classes/"]
        )
    ]
)
