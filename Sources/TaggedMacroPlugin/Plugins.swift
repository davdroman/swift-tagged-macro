import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct TaggedMacroPlugin: CompilerPlugin {
	let providingMacros: [any Macro.Type] = [
		TaggedMacro.self,
	]
}
