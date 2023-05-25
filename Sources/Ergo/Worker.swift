// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowReactiveSwift
import ReactiveSwift
import EnumKit

public final class Worker<Input, Output: WorkerOutput> {
	private let work: Work
	private let noop = SignalProducer<Output, Never>.never

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
	typealias Work = (Input) async -> Output

	enum State: CaseAccessible {
		case ready
		case working(Input)
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
		state = .working(input)
	}

	func mapSuccess<Action: WorkflowAction>(_ action: @escaping (Output.Success?) -> Action) -> AnyWorkflow<Void, Action> {
		self
			.mapOutput(\.success)
			.mapOutput(action)
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

	static func working(
		with input: Input,
		by work: @escaping Work
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
    
	static func working(by work: @escaping Work) -> Self {
		.init(
			state: .working(()),
			work: work
		)
	}
}

// MARK: -
extension Worker: WorkflowReactiveSwift.Worker {
	// MARK: Worker
	public func run() -> SignalProducer<Output, Never> {
		switch state {
		case let .working(input):
			return .init { observer, _ in
				Task {
					let output = await self.work(input)
					if let success = output.success {
						self.state = .ready
						observer.send(value: .success(success))
					} else if let failure = output.failure {
						self.state = .failed(failure)
						observer.send(value: .failure(failure))
					}
					observer.sendCompleted()
				}
			}
		default:
			return noop
		}
	}

	public func isEquivalent(to otherWorker: Worker<Input, Output>) -> Bool {
		false
	}
}
