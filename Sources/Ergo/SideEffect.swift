// Copyright © Fleuronic LLC. All rights reserved.

#if swift(<5.9)
import Workflow
#else
public import Workflow
#endif

public typealias SideEffect<Action: WorkflowAction> = @Sendable (Lifetime) async -> Action?
