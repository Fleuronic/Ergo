// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import SwiftUI
import Workflow

struct PublishedView<View: ScreenBacked> where View.Screen: PublishedScreen {
	private let view: View

	@ObservedObject
	private var screenPublisher: ScreenPublisher<View.Screen>

	init(
		view: View,
		screenPublisher: ScreenPublisher<View.Screen>
	) {
		self.view = view
		self.screenPublisher = screenPublisher
	}
}

// MARK: -
extension PublishedView: SwiftUI.View {
	var body: some SwiftUI.View {
		view.body(with: screenPublisher.screen)
	}
}
