// Copyright © Fleuronic LLC. All rights reserved.

public struct Action<Value> {
	private let perform: (Value) -> Void
}

// MARK: -
public extension Action {
	init(_ perform: @escaping (Value) -> Void) {
		self.perform = perform
	}

	func callAsFunction(_ value: Value) {
		perform(value)
	}
}

// MARK: -
public extension Action where Value == Void {
	func callAsFunction() {
		perform(())
	}
}

// MARK: -
extension Action: Equatable {
	// MARK: Equatable
	public static func ==(lhs: Self, rhs: Self) -> Bool { true }
}
