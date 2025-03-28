// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sgp4PropApp",
    platforms: [
        .macOS(.v11)                    // minimum macOS version v11 (Big Sur)
    ],
    dependencies: [
        .package(url: "https://github.com/gavineadie/Sgp4PropLib.git", from: "9.0.0"),
//      .package(name: "Sgp4PropLib", path: "../Sgp4PropLib")
    ],
    targets: [
        .executableTarget(
            name: "Sgp4PropApp",
            dependencies: ["Sgp4PropLib"],
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]),
    ]
)
