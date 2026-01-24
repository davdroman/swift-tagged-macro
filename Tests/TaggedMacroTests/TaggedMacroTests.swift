import TaggedMacro
import Testing

enum ContextA {
	struct User {
		#Tagged<Int>("ID")
		#Tagged<Int>("Age")

		let id: ID
		let age: Age
	}
}

enum ContextB {
	struct User {
		#Tagged<Int>("ID")
		#Tagged<Int>("Age")

		let id: ID
		let age: Age
	}
}

@Suite
struct TaggedMacroTests {
	struct User {
		#Tagged<Int>("ID")
		#Tagged<Int>("Age")

		let id: ID
		let age: Age

		init(id: ID, age: Age) {
			self.id = id
			self.age = age
		}
	}

	@Test func distinct() {
		#expect(ContextA.User.ID.self != ContextB.User.ID.self)
		#expect(ContextA.User.Age.self != ContextB.User.Age.self)
		#expect(ContextA.User.ID.self != ContextA.User.Age.self)
		#expect(ContextA.User.ID.self != ContextB.User.Age.self)
	}

	@Test func rawTypes() {
		#expect(ContextA.User.ID.self == Tagged<(ContextA.User, ID: ()), Int>.self)
		#expect(ContextA.User.Age.self == Tagged<(ContextA.User, Age: ()), Int>.self)
		#expect(ContextB.User.ID.self == Tagged<(ContextB.User, ID: ()), Int>.self)
		#expect(ContextB.User.Age.self == Tagged<(ContextB.User, Age: ()), Int>.self)
	}

	@Test func initialization() {
		let id: ContextA.User.ID = 1
		let age: ContextA.User.Age = 42
		#expect(id == 1)
		#expect(age == 42)
	}

	@Test func integration() {
		let user = ContextA.User(id: 1, age: 42)
		#expect(user.id == 1)
		#expect(user.age == 42)
	}
}
