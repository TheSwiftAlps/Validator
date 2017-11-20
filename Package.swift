// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Validator",
    products: [
        .library(name: "RequestEngine", targets: ["RequestEngine"]),
        .library(name: "Infrastructure", targets: ["Infrastructure"]),
        .library(name: "Scenarios", targets: ["Scenarios"]),
        .executable(name: "Validator", targets: ["Validator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "2.1.0"),
        .package(url: "https://github.com/iamjono/LoremSwiftum.git", from: "0.0.3"),

    ],
    targets: [
        .target(name: "RequestEngine", dependencies: []),
        .target(name: "Infrastructure", dependencies: ["RequestEngine", "LoremSwiftum"]),
        .target(name: "Scenarios", dependencies: ["Infrastructure"]),
        .target(name: "Validator", dependencies: ["Scenarios", "Rainbow"]),
    ]
)
