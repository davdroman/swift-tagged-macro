// swift-tools-version: 6.1

import CompilerPluginSupport
import PackageDescription

let package = Package(
	name: "swift-tagged-macro",
	platforms: [
		.iOS(.v13),
		.macCatalyst(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.visionOS(.v1),
		.watchOS(.v6),
	],
	products: [
		.library(name: "TaggedMacro", targets: ["TaggedMacro"]),
	],
	targets: [
		.target(
			name: "TaggedMacro",
			dependencies: [
				.product(name: "Tagged", package: "swift-tagged"),
				"TaggedMacroPlugin",
			],
		),
		.testTarget(
			name: "TaggedMacroTests",
			dependencies: [
				"TaggedMacro",
			],
		),

		.macro(
			name: "TaggedMacroPlugin",
			dependencies: [
				.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
				.product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
			],
		),
		.testTarget(
			name: "TaggedMacroPluginTests",
			dependencies: [
				"TaggedMacroPlugin",
				.product(name: "MacroTesting", package: "swift-macro-testing"),
				.product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
			],
		),
	],
)

package.dependencies += [
	.package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.6.0"),
	.package(url: "https://github.com/swiftlang/swift-syntax", "600.0.0"..<"603.0.0"),
	.package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.1.0"),
]

for target in package.targets {
	target.swiftSettings = target.swiftSettings ?? []
	target.swiftSettings? += [
		.enableUpcomingFeature("ExistentialAny"),
		.enableUpcomingFeature("InternalImportsByDefault"),
		.enableUpcomingFeature("MemberImportVisibility"),
	]
}
