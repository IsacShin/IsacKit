// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IsacKit",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "IsacKit",
            targets: ["IsacKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/IsacShin/IsacUIComponent.git", from: "0.0.2"),
        .package(url: "https://github.com/IsacShin/IsacNetwork.git", from: "0.0.2"),
        .package(url: "https://github.com/IsacShin/IsacStorage.git", from: "0.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "IsacKit"
            ,dependencies: ["IsacUIComponent", "IsacNetwork", "IsacStorage"]
        ),
        .testTarget(
            name: "IsacKitTests",
            dependencies: ["IsacKit"]
        ),
    ]
)
