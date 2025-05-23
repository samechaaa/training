// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Usecase",
    products: [
        .library(
            name: "Usecase",
            targets: ["Usecase"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.8.0"),
        .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "Usecase",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                "Domain"
            ]
        ),
        .testTarget(
            name: "UsecaseTests",
            dependencies: ["Usecase"]
        ),
    ]
)
