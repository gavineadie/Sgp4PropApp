// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sgp4PropApp",
    platforms: [
        .macOS(.v11)                    // minimum macOS version v11 (Big Sur)
    ],
    dependencies: [
        .package(url: "https://github.com/gavineadie/Sgp4PropLib.git", from: "0.0.1"),
    ],
    targets: [
        .executableTarget(
            name: "Sgp4PropApp", dependencies: ["Sgp4PropLib"]),
        .testTarget(
            name: "Sgp4PropAppTests", dependencies: ["Sgp4PropApp", "Sgp4PropLib"]),
    ]
)
