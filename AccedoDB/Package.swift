// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccedoDB",
    products: [
        .library(
            name: "AccedoDB",
            targets: ["AccedoDB"]
        ),
    ],
    dependencies: [
        .package(path: "../AccedoLogging")
    ],
    targets: [
        .target(
            name: "AccedoDB",
            dependencies: [
                .product(name: "AccedoLogging", package: "AccedoLogging")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "AccedoDBTests",
            dependencies: ["AccedoDB"]
        ),
    ]
)
