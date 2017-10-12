// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Validator",
    products: [
        .library(name: "RequestEngine", targets: ["RequestEngine"]),
        .executable(name: "Validator", targets: ["Validator"]),
    ],
    targets: [
        .target(name: "RequestEngine", dependencies: []),
        .target(name: "Validator", dependencies: ["RequestEngine"]),
        .testTarget(name: "ValidatorTests", dependencies: ["RequestEngine"])
    ]
)
