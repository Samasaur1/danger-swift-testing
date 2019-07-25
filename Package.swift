// swift-tools-version:5.0
// Managed by ice

import PackageDescription

let package = Package(
    name: "DangerSwiftTesting",
    products: [
        .library(name: "DangerSwiftTesting", targets: ["DangerSwiftTesting"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "DangerSwiftTesting", dependencies: []),
        .testTarget(name: "DangerSwiftTestingTests", dependencies: ["DangerSwiftTesting", "Danger"]),
    ]
)
