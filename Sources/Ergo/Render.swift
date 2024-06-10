// Copyright © Fleuronic LLC. All rights reserved.

import struct Workflow.Sink
import struct Workflow.AnyWorkflow
import class Workflow.RenderContext
import protocol Workflow.WorkflowAction

public extension RenderContext {
	func render<Rendering, Action: WorkflowAction> (
		workflows: [AnyWorkflow<Void, Action>] = [],
		keyedWorkflows: [String: AnyWorkflow<Void, Action>] = [:],
		render: (Sink<Action>) -> Rendering
	) -> Rendering where Action.WorkflowType == WorkflowType {
		workflows.forEach { workflow in workflow.running(in: self) }
		keyedWorkflows.forEach { key, workflow in workflow.running(in: self, key: key) }
		return render(makeSink(of: Action.self))
	}
}
