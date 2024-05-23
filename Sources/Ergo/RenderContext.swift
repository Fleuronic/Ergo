// Copyright © Fleuronic LLC. All rights reserved.

import Workflow

public extension RenderContext {
	func render<Rendering, Action: WorkflowAction> (
		render: (Sink<Action>) -> Rendering,
		@WorkflowBuilder running workflows: () -> [AnyWorkflow<Void, Action>] = { [] }
	) -> Rendering where Action.WorkflowType == WorkflowType {
		workflows().enumerated().forEach { $1.running(in: self, key: "\($0)") }
		return render(makeSink(of: Action.self))
	}
}
