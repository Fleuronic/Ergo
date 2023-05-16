// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI

public extension RenderContext {
	func render<Rendering, Action: WorkflowAction> (
		render: (Sink<Action>) -> Rendering,
		@WorkflowBuilder running workflows: () -> [AnyWorkflow<Void, Action>] = { [] }
	) -> Rendering where Action.WorkflowType == WorkflowType {
		workflows().forEach { $0.running(in: self) }
		return render(makeSink(of: Action.self))
	}
}
