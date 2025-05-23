// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Infrastructure",
            targets: ["Infrastructure"]
        ),
    ],
    dependencies: [
        .package(path: "../Data"),
        .package(url: "git@github.com:galapagos-ada/glpgs-ios-api-client.git", branch: "higashi/add-api-client"),
    ],
    targets: [
        .target(
            name: "Infrastructure",
            dependencies: [
                "Data",
                .product(name: "GlpgsAPIClient", package: "glpgs-ios-api-client")
            ]
        ),
        .testTarget(
            name: "InfrastructureTests",
            dependencies: ["Infrastructure"]
        ),
    ]
)
