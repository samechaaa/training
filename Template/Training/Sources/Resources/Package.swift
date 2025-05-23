// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Resources",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Resources",
            targets: ["Resources"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/mac-cain13/R.swift.git", from: "7.8.0")
    ],
    targets: [
        .target(
            name: "Resources",
            dependencies: [.product(name: "RswiftLibrary", package: "R.swift")],
            resources: [.process("Assets")],
            plugins: [.plugin(name: "RswiftGeneratePublicResources", package: "R.swift")]
        )
    ]
)
