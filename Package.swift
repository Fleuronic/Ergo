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
		)
    ],
    dependencies: [
        .package(url: "https://github.com/Fleuronic/workflow-swift", branch: "main"),
		.package(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", branch: "swift-concurrency"),
		.package(url: "https://github.com/gringoireDM/EnumKit", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "Ergo",
			dependencies: [
				"EnumKit",
				"ReactiveSwift",
				.product(name: "WorkflowUI", package: "workflow-swift"),
				.product(name: "WorkflowConcurrency", package: "workflow-swift")
			]
		)
    ]
)
