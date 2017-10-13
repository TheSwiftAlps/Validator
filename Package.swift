// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Validator",
    products: [
        .library(name: "RequestEngine", targets: ["RequestEngine"]),
        .library(name: "Tests", targets: ["Tests"]),
        .executable(name: "Validator", targets: ["Validator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "2.1.0")
    ],
    targets: [
        .target(name: "RequestEngine", dependencies: []),
        .target(name: "Tests", dependencies: ["RequestEngine", "Rainbow"]),
        .target(name: "Validator", dependencies: ["RequestEngine", "Tests", "Rainbow"]),
    ]
)
