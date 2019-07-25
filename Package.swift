// swift-tools-version:5.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "DangerSwiftTesting",
    products: [
        .library(name: "DangerSwiftTesting", targets: ["DangerSwiftTesting"]),
    ],
    targets: [
        .target(name: "DangerSwiftTesting", dependencies: []),
        .testTarget(name: "DangerSwiftTestingTests", dependencies: ["DangerSwiftTesting"]),
    ]
)
