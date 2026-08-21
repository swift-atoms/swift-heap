// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-heap-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(name: "Heap Primitive", targets: ["Heap Primitive"]),
        .library(name: "Heap Primitives", targets: ["Heap Primitives"]),

        .library(name: "Heap Primitives Test Support", targets: ["Heap Primitives Test Support"]),

    ],
    dependencies: [

        .package(
            url: "https://github.com/swift-primitives/swift-comparison-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-index-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-buffer-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-buffer-linear-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-storage-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-memory-allocation-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-memory-heap-primitives.git",
            branch: "main"
        ),

        .package(
            url: "https://github.com/swift-primitives/swift-collection-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-input-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-sequence-primitives.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Heap Primitive",
            dependencies: [

                .product(name: "Store Protocol Primitives", package: "swift-storage-primitives"),
                .product(name: "Buffer Protocol Primitives", package: "swift-buffer-primitives"),

                .product(name: "Buffer Primitive", package: "swift-buffer-primitives"),
                .product(
                    name: "Buffer Linear Primitive",
                    package: "swift-buffer-linear-primitives"
                ),
                .product(name: "Storage Primitive", package: "swift-storage-primitives"),
                .product(
                    name: "Storage Contiguous Primitives",
                    package: "swift-storage-primitives"
                ),
                .product(name: "Memory Heap Primitives", package: "swift-memory-heap-primitives"),

                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation-primitives"
                ),
                .product(
                    name: "Memory Allocator Protocol Primitives",
                    package: "swift-memory-allocation-primitives"
                ),

                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
            ]
        ),

        .target(
            name: "Heap Primitives",
            dependencies: [
                "Heap Primitive"
            ]
        ),

        .testTarget(
            name: "Heap Primitives Tests",
            dependencies: [
                "Heap Primitives",
                "Heap Primitives Test Support",
                .product(name: "Index Primitives Test Support", package: "swift-index-primitives"),
            ]
        ),

        .target(
            name: "Heap Primitives Test Support",
            dependencies: [
                "Heap Primitives",
                .product(
                    name: "Buffer Primitives Test Support",
                    package: "swift-buffer-primitives"
                ),
                .product(name: "Index Primitives Test Support", package: "swift-index-primitives"),
                .product(
                    name: "Collection Primitives Test Support",
                    package: "swift-collection-primitives"
                ),
                .product(name: "Input Primitives Test Support", package: "swift-input-primitives"),
                .product(
                    name: "Sequence Primitives Test Support",
                    package: "swift-sequence-primitives"
                ),
            ],
            path: "Tests/Support"
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
