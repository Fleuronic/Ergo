// Copyright © Fleuronic LLC. All rights reserved.

import struct Workflow.Sink
import struct Workflow.AnyWorkflow
import class Workflow.RenderContext
import protocol Workflow.WorkflowAction

public extension RenderContext {
	func render<Rendering, Action: WorkflowAction> (
		render: (Sink<Action>) -> Rendering,
		@WorkflowBuilder running workflows: () -> [AnyWorkflow<Void, Action>] = { [] }
	) -> Rendering where Action.WorkflowType == WorkflowType {
		workflows().enumerated().forEach { index, workflow in
			let key = index > 0 ? "\(index)" : .init()
			workflow.running(in: self, key: key) 
		}
		
		return render(makeSink(of: Action.self))
	}
}
