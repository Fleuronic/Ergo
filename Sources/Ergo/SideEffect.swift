// Copyright © Fleuronic LLC. All rights reserved.

import Workflow

public typealias SideEffect<Action: WorkflowAction> = @Sendable (Lifetime) async -> Action?
