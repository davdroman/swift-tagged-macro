# #Tagged

[![CI](https://github.com/davdroman/swift-tagged-macro/actions/workflows/ci.yml/badge.svg)](https://github.com/davdroman/swift-tagged-macro/actions/workflows/ci.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdavdroman%2Fswift-tagged-macro%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/davdroman/swift-tagged-macro)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdavdroman%2Fswift-tagged-macro%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/davdroman/swift-tagged-macro)

A Swift macro built on top of Point-Free's [Tagged](https://github.com/pointfreeco/swift-tagged) library, with one key improvement: zero boilerplate, even in cases of collision.

## Motivation

We often work with types that are far too general or hold far too many values than what is necessary for our domain. Sometimes we just want to differentiate between two seemingly equivalent values at the type level.

[Tagged](https://github.com/pointfreeco/swift-tagged) solves this, but [handling tag collisions](https://github.com/pointfreeco/swift-tagged#handling-tag-collisions) for the same underlying types quickly becomes verbose:

```swift
struct User {
    enum EmailTag {}
    enum AddressTag {}
    typealias Email = Tagged<EmailTag, String>
    typealias Address = Tagged<AddressTag, String>
}
```

You can also use tuple tricks:

```swift
struct User {
    typealias Email = Tagged<(User, email: ()), String>
    typealias Address = Tagged<(User, address: ()), String>
}
```

But this is still quite verbose, not very memorable, and can lead to collisions if not careful.

With `#Tagged`, you can just write:

```swift
struct User {
    #Tagged<String>("Email")
    #Tagged<String>("Address")
}
```

Which expands to:

```swift
struct User {
    typealias Email = Tagged<(User, Email: ()), String>
    typealias Address = Tagged<(User, Address: ()), String>
}
```

## Installation

```swift
.package(url: "https://github.com/davdroman/swift-tagged-macro", from: "0.1.0"),
```

```swift
.product(name: "TaggedMacro", package: "swift-tagged-macro"),
```
