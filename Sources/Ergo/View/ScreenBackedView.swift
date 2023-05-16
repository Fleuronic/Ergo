// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
import WorkflowUI

public protocol ScreenBackedView {
	associatedtype Body: SwiftUI.View
	associatedtype Screen: WorkflowUI.Screen

	init()

	func body(backedBy screen: Screen) -> Body
}
