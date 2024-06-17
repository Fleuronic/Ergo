// Copyright © Fleuronic LLC. All rights reserved.

import protocol EnumKit.CaseAccessible

public protocol WorkerOutput<Success> {
	associatedtype Success
	associatedtype Failure

	var success: Success? { get }
	var failure: Failure? { get }

	static func success(_: Success) -> Self
	static func failure(_: Failure) -> Self
}

// MARK: -
extension Result: @retroactive CaseAccessible {}

extension Result: WorkerOutput {
	// MARK: WorkerOutput
	public var success: Success? { associatedValue() }
	public var failure: Failure? { associatedValue() }
}

// MARK: -
extension Optional: WorkerOutput {
	// MARK: WorkerOutput
	public typealias Success = Self
	public typealias Failure = Void?

	public var success: Success? { self }
	public var failure: Failure? { nil }

	public static func success(_ success: Success) -> Self { success }
	public static func failure(_ failure: Failure) -> Self { nil }
}
