import MacroTesting
import TaggedMacroPlugin
import Testing

@Suite(
	.macros(
		["Tagged": TaggedMacro.self],
		indentationWidth: .tab,
		record: .missing
	)
)
struct TaggedMacroPluginTests {
	@Test func insideStruct() {
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

	@Test func insideNestedStruct() {
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

	@Test func insideClass() {
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

	@Test func insideNestedClass() {
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

	@Test func insideEnum() {
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

	@Test func insideNestedEnum() {
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

	@Test func insideActor() {
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

	@Test func insideNestedActor() {
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

	@Test func asTopLevelDeclarations() {
		assertMacro {
			"""
			#Tagged<UUID>("ID")
			private #Tagged<String>("Email")
			"""
		} expansion: {
			"""
			typealias ID = Tagged<(Void, ID: ()), UUID>
			private typealias Email = Tagged<(Void, Email: ()), String>
			"""
		}
	}

	@Test func trimmingWhitespace() {
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

	@Test func errorEmptyTypealiasName() {
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
