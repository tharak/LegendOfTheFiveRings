// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LegendOfTheFiveRings",
    products: [
        .library(
            name: "LegendOfTheFiveRings",
            targets: ["LegendOfTheFiveRings"]),
    ],
    targets: [
        .target(
            name: "LegendOfTheFiveRings",
            dependencies: [],
            resources: [.copy("Resources")]),
        .testTarget(
            name: "LegendOfTheFiveRingsTests",
            dependencies: ["LegendOfTheFiveRings"]),
    ]
)
