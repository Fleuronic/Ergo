// Copyright © Fleuronic LLC. All rights reserved.

import EnumKit

public protocol WorkerOutput {
	associatedtype Success
	associatedtype Failure

	var success: Success? { get }
	var failure: Failure? { get }

	static func success(_: Success) -> Self
	static func failure(_: Failure) -> Self
}

// MARK: -
extension Result: CaseAccessible {}

extension Result: WorkerOutput {
	public var success: Success? { associatedValue() }
	public var failure: Failure? { associatedValue() }
}

extension Optional: WorkerOutput {
	public typealias Success = Self
	public typealias Failure = Never

	public var success: Success? { self }
	public var failure: Failure? { nil }

	public static func success(_ success: Success) -> Self { success }
	public static func failure(_ failure: Failure) -> Self {}
}
