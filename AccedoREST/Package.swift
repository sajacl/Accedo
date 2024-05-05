// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccedoREST",
    products: [
        .library(
            name: "AccedoREST",
            targets: ["AccedoREST"]
        ),
    ],
    dependencies: [
        .package(path: "../AccedoLogging")
    ],
    targets: [
        .target(
            name: "AccedoREST",
            dependencies: [
                .product(name: "AccedoLogging", package: "AccedoLogging")
            ]
        ),
        .testTarget(
            name: "AccedoRESTTests",
            dependencies: ["AccedoREST"]
        ),
    ]
)
