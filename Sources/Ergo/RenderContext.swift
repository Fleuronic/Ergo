// Copyright © Fleuronic LLC. All rights reserved.

import Workflow
import WorkflowUI

public extension RenderContext {
	func render<Screen: WorkflowUI.Screen, Action: WorkflowAction> (
		screen: (Sink<Action>) -> Screen,
		@WorkflowBuilder running workflows: () -> [AnyWorkflow<Void, Action>] = { [] }
	) -> AnyScreen where Action.WorkflowType == WorkflowType {
		workflows().forEach { $0.running(in: self) }
		return screen(makeSink(of: Action.self)).asAnyScreen()
	}
}
