// Copyright © Fleuronic LLC. All rights reserved.

import protocol WorkflowUI.Screen
import protocol Layoutless.AnyLayout

public protocol Layoutable {
	associatedtype Screen: WorkflowUI.Screen

	func layout(with screen: some ScreenProxy<Screen>) -> AnyLayout
}
