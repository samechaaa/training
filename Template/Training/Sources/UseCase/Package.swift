// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "UseCase",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "UseCase",
            targets: ["UseCase"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.8.0"),
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "UseCase",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                "Domain"
            ]
        ),
        .testTarget(
            name: "UseCaseTests",
            dependencies: ["UseCase"]
        ),
    ]
)
