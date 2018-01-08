// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ArrowKit",
    products: [
        .library(
            name: "ArrowKit",
            targets: ["ArrowKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ArrowKit",
            dependencies: []
        ),
        .testTarget(
            name: "ArrowKitTests",
            dependencies: ["ArrowKit"]
        ),
    ]
)
