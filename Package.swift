// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LegendOfTheFiveRings",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v14),
        .macOS(SupportedPlatform.MacOSVersion.v11),
        ],
    products: [
        .library(
            name: "LegendOfTheFiveRings",
            targets: ["LegendOfTheFiveRings"]),
    ],
    targets: [
        .target(
            name: "LegendOfTheFiveRings",
            dependencies: [],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "LegendOfTheFiveRingsTests",
            dependencies: ["LegendOfTheFiveRings"]),
    ]
)
