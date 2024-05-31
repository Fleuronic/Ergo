// Copyright © Fleuronic LLC. All rights reserved.

import struct Workflow.AnyWorkflow
import protocol Workflow.WorkflowAction

@resultBuilder public struct WorkflowBuilder {
	public static func buildBlock<Action: WorkflowAction>(_ workflows: AnyWorkflow<Void, Action>...) -> [AnyWorkflow<Void, Action>] {
		workflows
	}
}
