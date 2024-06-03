// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit)

import protocol WorkflowUI.Screen

public protocol ScreenBacked {
	associatedtype Screen: WorkflowUI.Screen
}

#endif
