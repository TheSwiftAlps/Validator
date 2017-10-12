// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Validator",
    products: [
        .library(name: "RequestEngine", targets: ["RequestEngine"]),
        .executable(name: "Validator", targets: ["Validator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "2.1.0")
    ],
    targets: [
        .target(name: "RequestEngine", dependencies: []),
        .target(name: "Validator", dependencies: ["RequestEngine", "Rainbow"]),
        .testTarget(name: "ValidatorTests", dependencies: ["RequestEngine"])
    ]
)
