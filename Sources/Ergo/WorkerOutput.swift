// Copyright © Fleuronic LLC. All rights reserved.

@preconcurrency public import ReactiveSwift

public protocol WorkerOutput<Success> {
	associatedtype Success
	associatedtype Failure: Error

	var results: AsyncStream<Result<Success, Failure>> { get }
}

// MARK: -
extension Result: WorkerOutput {}

extension Result where Success: Sendable {
	// MARK: WorkerOutput
	public var results: AsyncStream<Result<Success, Failure>> {
		.init { continuation in
			continuation.yield(self)
			continuation.finish()
		}
	}
}

// MARK: -
extension Optional: WorkerOutput {
	public typealias Success = Wrapped
	public typealias Failure = Never
}

extension Optional where Wrapped: Sendable {
	// MARK: WorkerOutput
	public var results: AsyncStream<Result<Wrapped, Never>> {
		.init { continuation in
			if let value = self {
				continuation.yield(.success(value))
			}
			continuation.finish()
		}
	}
}

// MARK: -
extension SignalProducer: WorkerOutput {
	public typealias Success = Value
	public typealias Failure = Error
}

extension SignalProducer where Value: Sendable {
	public var results: AsyncStream<Result<Value, Error>> {
		.init { continuation in
			let disposable = start { event in
				switch event {
				case let .value(value):
					continuation.yield(.success(value))
				case .completed, .interrupted:
					continuation.finish()
				case let .failed(error):
					continuation.yield(.failure(error))
				}
			}

			continuation.onTermination = { _ in
				disposable.dispose()
			}
		}
	}
}
