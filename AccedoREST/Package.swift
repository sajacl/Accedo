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
    targets: [
        .target(
            name: "AccedoREST"
        ),
        .testTarget(
            name: "AccedoRESTTests",
            dependencies: ["AccedoREST"]
        ),
    ]
)
