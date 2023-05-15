// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import WorkflowUI
import Layoutless
import Inject

public protocol ReactiveScreen: Screen where View.Screen == Self {
	associatedtype View: UIView & Layoutable
	associatedtype Strings
}

// MARK: -
public extension ReactiveScreen {
	typealias ScreenString = (Strings.Type) -> String

	// MARK: Screen
	func viewControllerDescription(environment: ViewEnvironment) -> ViewControllerDescription {
		.init(
			type: Inject.ViewControllerHost<ReactiveViewController<View>>.self,
			build: { .init(.init(screen: self, environment: environment)) },
			update: { $0.instance.update(screen: self, environment: environment) }
		)
	}
}
