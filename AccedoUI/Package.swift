// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccedoUI",
    defaultLocalization: "en",
    products: [
        .library(
            name: "AccedoUI",
            targets: ["AccedoUI"]
        ),
    ],
    targets: [
        .target(
            name: "AccedoUI",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "AccedoUITests",
            dependencies: ["AccedoUI"]
        ),
    ]
)
