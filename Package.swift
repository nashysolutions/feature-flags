// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "feature-flags",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "FeatureFlags",
            targets: ["FeatureFlags"]),
    ],
    dependencies: [
        .package(url: "git@github.com:nashysolutions/versioning.git", .upToNextMinor(from: "2.2.0"))
    ],
    targets: [
        .target(
            name: "FeatureFlags",
            dependencies: [
                .product(name: "Versioning", package: "versioning")
            ]
        ),
        .testTarget(
            name: "FeatureFlagsTests",
            dependencies: ["FeatureFlags"]
        ),
    ]
)
