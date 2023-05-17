// Copyright © Fleuronic LLC. All rights reserved.

import WorkflowUI

public protocol WrappedScreen: Screen {
	associatedtype Screen

	init(screen: Screen)
}

// MARK: -
public extension WrappedScreen {
	static func wrap(screen: Screen) -> AnyScreen {
		self.init(screen: screen).asAnyScreen()
	}
}
