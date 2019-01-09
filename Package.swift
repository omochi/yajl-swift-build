// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "yajl",
    products: [
        .library(name: "yajl", targets: ["yajl"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "yajl", dependencies: []),
        .testTarget(name: "yajlTests", dependencies: ["yajl"]),
    ]
)
