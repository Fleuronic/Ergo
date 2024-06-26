// Copyright © Fleuronic LLC. All rights reserved.

import struct Identity.Identifier
import struct ReactiveSwift.SignalProducer

public protocol WorkerOutput<Success> {
	associatedtype Success
	associatedtype Failure: Error

	var results: AsyncStream<Result<Success, Failure>> { get }
}

// MARK: -
extension Result: WorkerOutput {
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

			continuation.onTermination = { @Sendable _ in
				disposable.dispose()
			}
		}
	}
}
