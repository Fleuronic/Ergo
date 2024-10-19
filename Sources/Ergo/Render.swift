// Copyright © Fleuronic LLC. All rights reserved.

#if swift(<5.9)
import Workflow
#else
public import Workflow
#endif

public extension RenderContext {
	func render<Rendering, Action: WorkflowAction & Sendable> (
		workflows: [AnyWorkflow<Void, Action>]? = nil,
		keyedWorkflows: [String: AnyWorkflow<Void, Action>]? = nil,
		sideEffects: [AnyHashable: SideEffect<Action>]? = nil,
		render: (Sink<Action>) -> Rendering
	) -> Rendering where Action.WorkflowType == WorkflowType {
		workflows?.forEach { workflow in workflow.running(in: self) }
		keyedWorkflows?.forEach { key, workflow in workflow.running(in: self, key: key) }
		
		let sink = makeSink(of: Action.self)
		sideEffects?.forEach { key, action in
			runSideEffect(key: key) { lifetime in
				let task = Task { @MainActor in
					if let action = await action(lifetime) {
						sink.send(action)
					}
				}
				
				lifetime.onEnded { task.cancel() }
			}
		}
		
		return render(sink)
	}
}
