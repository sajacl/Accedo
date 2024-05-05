// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccedoLogging",
    products: [
        .library(
            name: "AccedoLogging",
            targets: ["AccedoLogging"]
        ),
    ],
    targets: [
        .target(
            name: "AccedoLogging")
    ]
)
