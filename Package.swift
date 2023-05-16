// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Ergo",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Ergo",
            targets: ["Ergo"]
		),
		.library(
			name: "ErgoSwiftUI",
			targets: ["ErgoSwiftUI"]
		),
		.library(
			name: "ErgoUIKit",
			targets: ["ErgoUIKit"]
		)
    ],
    dependencies: [
        .package(url: "https://github.com/square/workflow-swift", from: "1.0.0-rc.1"),
		.package(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", branch: "swift-concurrency"),
		.package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa", from: "12.0.0"),
        .package(url: "https://github.com/DeclarativeHub/Layoutless", .upToNextMajor(from: "0.4.0")),
		.package(url: "https://github.com/gringoireDM/EnumKit", from: "1.1.0"),
		.package(url: "https://github.com/Fleuronic/Inject.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Ergo",
			dependencies: [
				"EnumKit",
				"Inject",
				.product(name: "WorkflowUI", package: "workflow-swift"),
				.product(name: "WorkflowReactiveSwift", package: "workflow-swift")
			],
			path: "Sources/Ergo"
		),
		.target(
			name: "ErgoSwiftUI",
			dependencies: ["Ergo"],
			path: "Sources/ErgoSwiftUI"
		),
		.target(
			name: "ErgoUIKit",
			dependencies: [
				"Ergo",
				"Layoutless",
				"ReactiveSwift",
				"ReactiveCocoa"
			],
			path: "Sources/ErgoUIKit"
		)
    ]
)
