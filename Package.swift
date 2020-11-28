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
            resources: [
                .process("Resources/Armors.json"),
                .process("Resources/Tattoos.json"),
                .process("Resources/Skills.json"),
                .process("Resources/Disadvantages.json"),
                .process("Resources/Advantages.json"),
                .process("Resources/Families.json"),
                .process("Resources/Weapons.json"),
                .process("Resources/ShadowlandsPowers.json"),
                .process("Resources/Spells.json"),
                .process("Resources/Schools.json"),
                .process("Resources/Ancestors.json"),
                .process("Resources/Katas.json"),
                .process("Resources/Kihos.json"),
                .process("Resources/Clans.json"),
            ]
        ),
        .testTarget(
            name: "LegendOfTheFiveRingsTests",
            dependencies: ["LegendOfTheFiveRings"]),
    ]
)
