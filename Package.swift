// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CalendarMenuBarApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "CalendarMenuBarApp", targets: ["CalendarMenuBarApp"])
    ],
    targets: [
        .executableTarget(
            name: "CalendarMenuBarApp",
            path: "CalendarMenuBarApp",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
