// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
import WorkflowUI
import Inject

public protocol PublishedScreen: Screen where View.Screen == Self {
	associatedtype View: ScreenBackedView
}

// MARK: -
public extension PublishedScreen {
	// MARK: Screen
	func viewControllerDescription(environment: ViewEnvironment) -> ViewControllerDescription {
		.init(
			type: Inject.ViewControllerHost<PublishedViewController<View>>.self,
			build: { .init(.init(screen: self, environment: environment)) },
			update: { $0.instance.update(screen: self, environment: environment) }
		)
	}
}
