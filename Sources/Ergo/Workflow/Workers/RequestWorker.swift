// Copyright © Fleuronic LLC. All rights reserved.

import WorkflowConcurrency

public struct RequestWorker<Result> {
	private let request: Request

	public init(request: @escaping Request) {
		self.request = request
	}
}

// MARK: -
public extension RequestWorker {
	typealias Request = () async -> Result
}

// MARK: -
extension RequestWorker: WorkflowConcurrency.Worker {
	public func run() async -> Result {
		await request()
	}

	public func isEquivalent(to otherWorker: Self) -> Bool {
		true
	}
}
