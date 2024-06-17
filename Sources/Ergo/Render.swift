// Copyright © Fleuronic LLC. All rights reserved.

@preconcurrency import Workflow

public extension RenderContext {
	func render<Rendering, Action: WorkflowAction & Sendable> (
		workflows: [AnyWorkflow<Void, Action>]? = nil,
		keyedWorkflows: [String: AnyWorkflow<Void, Action>]? = nil,
		sideEffects: [String: SideEffect<Action>]? = nil,
		render: (Sink<Action>) -> Rendering
	) -> Rendering where Action.WorkflowType == WorkflowType {
		workflows?.forEach { workflow in workflow.running(in: self) }
		keyedWorkflows?.forEach { key, workflow in workflow.running(in: self, key: key) }

		let sink = makeSink(of: Action.self)
		sideEffects?.forEach { key, action in
			runSideEffect(key: key) { lifetime in
				Task { @MainActor in
					await action(lifetime).map(sink.send)
				}
			}
		}

		return render(sink)
	}
}
