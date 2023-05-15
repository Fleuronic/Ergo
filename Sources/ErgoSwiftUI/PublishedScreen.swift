// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
import WorkflowUI
import Inject

public protocol PublishedScreen: Screen where View.Screen == Self {
	associatedtype View: Bodied
	associatedtype Strings
}

// MARK: -
public extension PublishedScreen {
	typealias ScreenString = (Strings.Type) -> String

	// MARK: Screen
	func viewControllerDescription(environment: ViewEnvironment) -> ViewControllerDescription {
		.init(
			type: Inject.ViewControllerHost<PublishedViewController<View>>.self,
			build: { .init(.init(screen: self, environment: environment)) },
			update: { $0.instance.update(screen: self, environment: environment) }
		)
	}
}
