// Copyright © Fleuronic LLC. All rights reserved.

public import Workflow

public typealias SideEffect<Action: WorkflowAction> = @Sendable (Lifetime) async -> Action?
