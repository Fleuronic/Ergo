// Copyright © Fleuronic LLC. All rights reserved.

import class Workflow.RenderContext
import struct Workflow.AnyWorkflow
import protocol Workflow.WorkflowAction

public extension RenderContext {
	func run<Action: WorkflowAction>(_ workers: AnyWorkflow<Void, Action>?...) where Action.WorkflowType == WorkflowType {
		workers.forEach { $0?.running(in: self) }
	}
}
