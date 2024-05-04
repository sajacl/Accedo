// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccedoTypes",
    products: [
        .library(
            name: "AccedoTypes",
            targets: ["AccedoTypes"]
        ),
    ],
    targets: [
        .target(
            name: "AccedoTypes"
        )
    ]
)
