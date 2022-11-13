// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sgp4PropApp",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
    	.package(path: "../Sgp4PropLib"),
    ],
    targets: [
        .executableTarget(
            name: "Sgp4PropApp",
            dependencies: [.product(name: "Sgp4PropLib", package: "Sgp4PropLib")]),
        .testTarget(
            name: "Sgp4PropAppTests",
            dependencies: ["Sgp4PropApp", .product(name: "Sgp4PropLib", package: "Sgp4PropLib")]),
    ]
)
