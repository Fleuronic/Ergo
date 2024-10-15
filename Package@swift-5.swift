// swift-tools-version:5.8
import PackageDescription

let package = Package(
	name: "Ergo",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "Ergo",
			targets: ["Ergo"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/Fleuronic/workflow-swift", branch: "main")
	],
	targets: [
		.target(
			name: "Ergo",
			dependencies: [
				.product(name: "WorkflowReactiveSwift", package: "workflow-swift")
			]
		)
	]
)

for target in package.targets {
	target.swiftSettings = [
		.enableUpcomingFeature("StrictConcurrency"),
		.enableExperimentalFeature("AccessLevelOnImport")
	]
}
