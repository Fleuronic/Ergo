// Copyright © Fleuronic LLC. All rights reserved.

import EnumKit
import Workflow
import WorkflowConcurrency

public final class Worker<Input, Output: WorkerOutput> {
	private let work: Work

	private var state: State

	init(
		state: State,
		work: @escaping Work
	) {
		self.state = state
		self.work = work
	}
}

// MARK: -
public extension Worker {
	typealias Work = (Input) async -> AsyncStream<Output>
	typealias Return = (Input) async -> Output

	enum State: CaseAccessible {
		case ready
		case working(Input, initial: Bool = true)
		case failed(Output.Failure)
	}

	var isReady: Bool {
		state ~= .ready
	}

	var isWorking: Bool {
		state ~= State.working
	}

	var errorContext: (Output.Failure, () -> Void)? {
		state.associatedValue().map { ($0, { self.state = .ready }) }
	}

	func start(with input: Input) {
		guard isReady else { return }
		state = .working(input)
	}

	func mapSuccess<Action: WorkflowAction>(_ action: @escaping (Output.Success?) -> Action) -> AnyWorkflow<Void, Action> {
		mapOutput(\.success)
			.mapOutput(action)
	}

	func flatMapSuccess<T, Action: WorkflowAction>(_ action: @escaping (Output.Success) -> Action) -> AnyWorkflow<Void, Action> where Output.Success == T? {
		mapSuccess { $0.map(action) ?? action(nil) }
	}

	func mapResult<Action: WorkflowAction>(
		success: @escaping (Output.Success) -> Action,
		failure: @escaping (Output.Failure) -> Action
	) -> AnyWorkflow<Void, Action> {
		mapOutput {
			let action = $0.success.map(success) ?? $0.failure.map(failure)
			return action!
		}
	}

	static func ready(to work: @escaping Work) -> Self {
		.init(
			state: .ready,
			work: work
		)
	}

	static func ready(to return: @escaping Return) -> Self {
		.init(
			state: .ready,
			return: `return`
		)
	}

	static func working(
		with input: Input,
		to return: @escaping Return
	) -> Self {
		.init(
			state: .working(input),
			return: `return`
		)
	}

	static func working(
		with input: Input,
		to work: @escaping Work
	) -> Self {
		.init(
			state: .working(input),
			work: work
		)
	}
}

// MARK: -
public extension Worker where Input == Void {
	func start() {
		start(with: ())
	}

	static func working(to return: @escaping Return) -> Self {
		.init(
			state: .working(()),
			return: `return`
		)
	}

	static func working(to work: @escaping Work) -> Self {
		.init(
			state: .working(()),
			work: work
		)
	}
}

// MARK: -
extension Worker {
	convenience init(
		state: State,
		return: @escaping Return
	) {
		self.init(
			state: state,
			work: { input in
				.init { continuation in
					Task {
						continuation.yield(await `return`(input))
						continuation.finish()
					}
				}
			}
		)
	}
}

// MARK: - 
extension Worker: WorkflowConcurrency.Worker {
	// MARK: Worker
	public func run() -> AsyncStream<Output> {
		switch state {
		case let .working(input, true):
			state = .working(input, initial: false)
			return .init { continuation in
				Task {
					for await output in await self.work(input) {
						if let success = output.success {
							continuation.yield(.success(success))
						} else if let failure = output.failure {
							self.state = .failed(failure)
							continuation.yield(.failure(failure))
							return
						}
					}
					self.state = .ready
					continuation.finish()
				}
			}
		default:
			return .init { $0.finish() }
		}
	}

	public func isEquivalent(to otherWorker: Worker<Input, Output>) -> Bool {
		false
	}
}
