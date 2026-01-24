import TaggedMacro
import Testing

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
		#expect(User.ID.self != User.Age.self)
	}

	@Test func rawTypes() {
		#expect(User.ID.self == Tagged<(User, ID: ()), Int>.self)
		#expect(User.Age.self == Tagged<(User, Age: ()), Int>.self)
	}

	@Test func initialization() {
		let id: User.ID = 1
		let age: User.Age = 42
		#expect(id == 1)
		#expect(age == 42)
	}

	@Test func integration() {
		let user = User(id: 1, age: 42)
		#expect(user.id == 1)
		#expect(user.age == 42)
	}
}
