// Copyright © Fleuronic LLC. All rights reserved.

import Layoutless
import WorkflowUI

public protocol Layoutable {
	associatedtype Screen: WorkflowUI.Screen

	func layout(with screen: some ScreenProxy<Screen>) -> AnyLayout
}
