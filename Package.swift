// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SQNetworkLogger",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SQNetworkLogger",
            targets: ["SQNetworkLogger"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.4"))
    ],
    targets: [
        .target(
            name: "SQNetworkLogger",
            dependencies: [
                .product(name: "Moya", package: "Moya")
            ]),
        .testTarget(
            name: "SQNetworkLoggerTests",
            dependencies: ["SQNetworkLogger"]),
    ]
)
