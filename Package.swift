// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LegendOfTheFiveRings2",
    products: [
        .library(
            name: "LegendOfTheFiveRings2",
            targets: ["LegendOfTheFiveRings2"]),
    ],
    targets: [
        .target(
            name: "LegendOfTheFiveRings2",
            dependencies: [],
            resources: [.copy("Resources")]),
        .testTarget(
            name: "LegendOfTheFiveRingsTests",
            dependencies: ["LegendOfTheFiveRings"]),
    ]
)
