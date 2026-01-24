// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
	name: "swift-tagged-macro",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6),
	],
	products: [
		.library(name: "TaggedMacro", targets: ["TaggedMacro"]),
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.1.0"),
		.package(url: "https://github.com/swiftlang/swift-syntax", "509.0.0"..<"602.0.0"),
		.package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.1.0"),
	],
	targets: [
		.target(
			name: "TaggedMacro",
			dependencies: [
				.product(name: "Tagged", package: "swift-tagged"),
				"TaggedMacroPlugin",
			]
		),
		.testTarget(
			name: "TaggedMacroTests",
			dependencies: [
				"TaggedMacro",
			]
		),

		.macro(
			name: "TaggedMacroPlugin",
			dependencies: [
				.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
				.product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
			]
		),
		.testTarget(
			name: "TaggedMacroPluginTests",
			dependencies: [
				"TaggedMacroPlugin",
				.product(name: "MacroTesting", package: "swift-macro-testing"),
				// For some reason, with Swift Syntax prebuilts enabled, we need to depend on SwiftCompilerPlugin here to work around error:
				// Compilation search paths unable to resolve module dependency: 'SwiftCompilerPlugin'
				.product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
			]
		),
	]
)
