// swift-tools-version:6.0
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
	],
	swiftLanguageModes: [.v6]
)

for target in package.targets {
	target.swiftSettings = [
		.enableUpcomingFeature("ExistentialAny"),
		.enableUpcomingFeature("InternalImportsByDefault")
	]
}
