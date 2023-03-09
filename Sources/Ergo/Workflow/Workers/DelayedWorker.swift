// Copyright © Fleuronic LLC. All rights reserved.

import WorkflowConcurrency

import struct Metric.Delay

public struct DelayedWorker {
	private let delay: Delay

	public init(delay: Delay) {
		self.delay = delay
	}
}

// MARK: -
extension DelayedWorker: WorkflowConcurrency.Worker {
	public func run() async {
		guard let nanoseconds = delay.nanoseconds else { return }
		try? await Task.sleep(nanoseconds: nanoseconds)
	}

	public func isEquivalent(to otherWorker: Self) -> Bool {
		true
	}
}
