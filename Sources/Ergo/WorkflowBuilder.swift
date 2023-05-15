// Copyright © Fleuronic LLC. All rights reserved.

import Workflow

@resultBuilder public struct WorkflowBuilder {
	public static func buildBlock<Action: WorkflowAction>(_ workflows: AnyWorkflow<Void, Action>...) -> [AnyWorkflow<Void, Action>] {
		workflows
	}
}
