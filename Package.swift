// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "TonSwift",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(name: "TonSwift", targets: ["TonSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/sunimp/tweetnacl-swiftwrap", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.0"),
    ],
    targets: [
        .target(
            name: "TonSwift",
            dependencies: [
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "TweetNacl", package: "tweetnacl-swiftwrap"),
            ]),
        .testTarget(
            name: "TonSwiftTests",
            dependencies: [
                .byName(name: "TonSwift"),
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "TweetNacl", package: "tweetnacl-swiftwrap"),
            ]),
    ]
)
