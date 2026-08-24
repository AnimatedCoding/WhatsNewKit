// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "WhatsNewKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "WhatsNewKit",
            targets: [
                "WhatsNewKit"
            ]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WhatsNewKit",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy")
            ]
        ),
        .testTarget(
            name: "WhatsNewKitTests",
            dependencies: [
                "WhatsNewKit"
            ],
            path: "Tests"
        )
    ]
)
