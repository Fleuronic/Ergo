// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit)

import protocol WorkflowUI.Screen

public protocol ScreenBacked {
	associatedtype Screen: WorkflowUI.Screen
}

#elseif canImport(AppKit)

import protocol WorkflowMenuUI.Pane

public protocol PaneBacked {
	associatedtype Pane: WorkflowMenuUI.Pane
}

#endif
