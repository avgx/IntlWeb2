// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "IntlWeb2",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "IntlWeb2", targets: ["IntlWeb2"]),
    ],
    dependencies: [
        .package(url: "https://github.com/avgx/IntlWireFormat", from: "1.0.0"),
        .package(url: "https://github.com/avgx/RequestResponse", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "IntlWeb2",
            dependencies: [
                .product(name: "IntlWireFormat", package: "IntlWireFormat"),
                .product(name: "RequestResponse", package: "RequestResponse"),
            ]
        ),
        .testTarget(
            name: "IntlWeb2Tests",
            dependencies: ["IntlWeb2"],
            resources: [.process("Resources")]
        ),
    ]
)
