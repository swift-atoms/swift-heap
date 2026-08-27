// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-heap",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Heap",
            targets: ["Heap"]
        ),
        .library(
            name: "Heap Test Support",
            targets: ["Heap Test Support"]
        ),
        .library(
            name: "Heap Apple Foundation Integration",
            targets: ["Heap Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-comparison.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-storage.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Heap",
            dependencies: [
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Storage", package: "swift-storage"),
            ]
        ),
        .target(
            name: "Heap Test Support",
            dependencies: ["Heap"]
        ),
        .target(
            name: "Heap Apple Foundation Integration",
            dependencies: ["Heap"]
        ),
        .testTarget(
            name: "Heap Tests",
            dependencies: [
                "Heap",
                "Heap Test Support",
                .product(name: "Comparison", package: "swift-comparison"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Storage", package: "swift-storage"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
