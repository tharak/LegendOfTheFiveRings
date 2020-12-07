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
    dependencies: [
        .package(name: "CoreDataModelDescription", url: "https://github.com/dmytro-anokhin/core-data-model-description.git", from: "0.0.9"),
    ],
    targets: [
        .target(
            name: "LegendOfTheFiveRings",
            dependencies: ["CoreDataModelDescription"],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "LegendOfTheFiveRingsTests",
            dependencies: ["LegendOfTheFiveRings"]),
    ]
)
