// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Composition",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Composition",
            targets: ["Composition"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.8.0"),
        .package(path: "../Domain"),
        .package(path: "../Data"),
        .package(path: "../Infrastructure"),
        .package(path: "../UseCase"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Composition",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                "Domain",
                "Data",
                "Infrastructure",
                "UseCase"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "CompositionTests",
            dependencies: ["Composition"]
        ),
    ]
)
