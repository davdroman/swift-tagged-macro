#if canImport(TaggedMacroPlugin)
import MacroTesting
import SnapshotTesting
import SwiftSyntax
@testable import TaggedMacroPlugin
import Testing

@Suite(
	.macros(
		["Tagged": TaggedMacro.self],
		indentationWidth: .tab,
		record: .missing,
	),
)
struct TaggedMacroPluginTests {
	@Test func `inside struct`() {
		assertMacro {
			"""
			struct User {
				#Tagged<UUID>("ID")
				private #Tagged<String>("Email")
			}
			"""
		} expansion: {
			"""
			struct User {
				typealias ID = Tagged<(User, ID: ()), UUID>
				private typealias Email = Tagged<(User, Email: ()), String>
			}
			"""
		}
	}

	@Test func `inside nested struct`() {
		assertMacro {
			"""
			enum Models {
				struct User {
					#Tagged<UUID>("ID")
					private #Tagged<String>("Email")
				}
			}
			"""
		} expansion: {
			"""
			enum Models {
				struct User {
					typealias ID = Tagged<(User, ID: ()), UUID>
					private typealias Email = Tagged<(User, Email: ()), String>
				}
			}
			"""
		}
	}

	@Test func `inside class`() {
		assertMacro {
			"""
			class User {
				#Tagged<UUID>("ID")
				private #Tagged<String>("Email")
			}
			"""
		} expansion: {
			"""
			class User {
				typealias ID = Tagged<(User, ID: ()), UUID>
				private typealias Email = Tagged<(User, Email: ()), String>
			}
			"""
		}
	}

	@Test func `inside nested class`() {
		assertMacro {
			"""
			enum Models {
				class User {
					#Tagged<UUID>("ID")
					private #Tagged<String>("Email")
				}
			}
			"""
		} expansion: {
			"""
			enum Models {
				class User {
					typealias ID = Tagged<(User, ID: ()), UUID>
					private typealias Email = Tagged<(User, Email: ()), String>
				}
			}
			"""
		}
	}

	@Test func `inside enum`() {
		assertMacro {
			"""
			enum User {
				#Tagged<UUID>("ID")
				private #Tagged<String>("Email")
			}
			"""
		} expansion: {
			"""
			enum User {
				typealias ID = Tagged<(User, ID: ()), UUID>
				private typealias Email = Tagged<(User, Email: ()), String>
			}
			"""
		}
	}

	@Test func `inside nested enum`() {
		assertMacro {
			"""
			enum Models {
				enum User {
					#Tagged<UUID>("ID")
					private #Tagged<String>("Email")
				}
			}
			"""
		} expansion: {
			"""
			enum Models {
				enum User {
					typealias ID = Tagged<(User, ID: ()), UUID>
					private typealias Email = Tagged<(User, Email: ()), String>
				}
			}
			"""
		}
	}

	@Test func `inside actor`() {
		assertMacro {
			"""
			actor User {
				#Tagged<UUID>("ID")
				private #Tagged<String>("Email")
			}
			"""
		} expansion: {
			"""
			actor User {
				typealias ID = Tagged<(User, ID: ()), UUID>
				private typealias Email = Tagged<(User, Email: ()), String>
			}
			"""
		}
	}

	@Test func `inside nested actor`() {
		assertMacro {
			"""
			enum Models {
				actor User {
					#Tagged<UUID>("ID")
					private #Tagged<String>("Email")
				}
			}
			"""
		} expansion: {
			"""
			enum Models {
				actor User {
					typealias ID = Tagged<(User, ID: ()), UUID>
					private typealias Email = Tagged<(User, Email: ()), String>
				}
			}
			"""
		}
	}

	// NB: top-level declarations are not supported for arbitrarily named freestanding declaration macros.
	// Hence the syntax below would not compile, but we're future-proofing it anyway just in case.
	// error: 'declaration' macros are not allowed to introduce arbitrary names at global scope
	@Test func `as top level declarations`() {
		assertMacro {
			"""
			// Module A
			#Tagged<UUID>("ID")
			private #Tagged<String>("Email")

			// Module B
			#Tagged<UUID>("ID")
			private #Tagged<String>("Email")
			"""
		} expansion: {
			"""
			// Module A
			typealias ID = Tagged<(Void, __macro_local_2IDfMu_: ()), UUID>
			private typealias Email = Tagged<(Void, __macro_local_5EmailfMu_: ()), String>

			// Module B
			typealias ID = Tagged<(Void, __macro_local_2IDfMu0_: ()), UUID>
			private typealias Email = Tagged<(Void, __macro_local_5EmailfMu0_: ()), String>
			"""
		}
	}

	@Test func `trimming whitespace`() {
		assertMacro {
			"""
			struct User {
				#Tagged<UUID>(" ID ")
				private #Tagged<String>(" Email ")
			}
			"""
		} expansion: {
			"""
			struct User {
				typealias ID = Tagged<(User, ID: ()), UUID>
				private typealias Email = Tagged<(User, Email: ()), String>
			}
			"""
		}
	}

	@Test func `error empty typealias name`() {
		assertMacro {
			"""
			struct User {
				#Tagged<Int>("")
				#Tagged<Int>("   ")
			}
			"""
		} diagnostics: {
			"""
			struct User {
				#Tagged<Int>("")
			              ┬─
			              ╰─ 🛑 Tagged macro requires a valid typealias name
				#Tagged<Int>("   ")
			              ┬────
			              ╰─ 🛑 Tagged macro requires a valid typealias name
			}
			"""
		}
	}
}
#endif
