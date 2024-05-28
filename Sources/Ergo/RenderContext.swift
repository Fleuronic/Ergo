// Copyright © Fleuronic LLC. All rights reserved.

import Workflow

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
