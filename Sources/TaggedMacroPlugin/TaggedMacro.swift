import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct TaggedMacro: DeclarationMacro {
	static func expansion(
		of node: some FreestandingMacroExpansionSyntax,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax] {
		guard
			let typealiasNameNode = node.arguments.first?.expression.as(StringLiteralExprSyntax.self),
			let rawTypealiasName = typealiasNameNode.segments.compactMap({ $0.as(StringSegmentSyntax.self)?.content.text }).first
		else {
			fatalError("Tagged macro requires a string literal argument for the typealias name")
		}
		let typealiasName = rawTypealiasName.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !typealiasName.isEmpty else {
			context.diagnose(
				Diagnostic(
					node: typealiasNameNode,
					message: MacroExpansionErrorMessage("Tagged macro requires a valid typealias name")
				)
			)
			return []
		}
		guard let rawValueType = node.genericArgumentClause?.arguments.first?.argument.as(IdentifierTypeSyntax.self)?.name.text else {
			fatalError("Tagged macro requires a raw value type specified as a generic argument <...>")
		}

		let taggedContextualType = if let structName = context.lexicalContext.first?.as(StructDeclSyntax.self)?.name.trimmed.text {
			structName
		} else if let className = context.lexicalContext.first?.as(ClassDeclSyntax.self)?.name.trimmed.text {
			className
		} else if let enumName = context.lexicalContext.first?.as(EnumDeclSyntax.self)?.name.trimmed.text {
			enumName
		} else if let actorName = context.lexicalContext.first?.as(ActorDeclSyntax.self)?.name.trimmed.text {
			actorName
		} else {
			"Void"
		}

		let uniqueTypealiasName = if taggedContextualType == "Void" {
			context.makeUniqueName(typealiasName).text
		} else {
			typealiasName
		}

		let taggedType = "Tagged<(\(taggedContextualType), \(uniqueTypealiasName): ()), \(rawValueType)>"

		return [
			"""
			typealias \(raw: typealiasName) = \(raw: taggedType) 
			""",
		]
	}
}
