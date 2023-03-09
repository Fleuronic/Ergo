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
            targets: [
				"Ergo"
			]
		)
    ],
    dependencies: [
        .package(url: "https://github.com/square/workflow-swift", from: "1.0.0-rc.1"),
		.package(url: "https://github.com/Fleuronic/Metric", branch: "main"),
		.package(url: "https://github.com/JohnSundell/Identity", from: "0.1.0"),
        .package(url: "https://github.com/DeclarativeHub/Layoutless", .upToNextMajor(from: "0.4.0")),
        .package(url: "https://github.com/DeclarativeHub/Bond", .upToNextMajor(from: "7.0.0")),
		.package(url: "https://github.com/Fleuronic/Inject.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Ergo",
			dependencies: [
				"Metric",
				"Identity",
				"Layoutless",
				"Bond",
				"Inject",
				.product(name: "WorkflowUI", package: "workflow-swift"),
				.product(name: "WorkflowConcurrency", package: "workflow-swift")
			]
		)
    ]
)
