// Copyright © Fleuronic LLC. All rights reserved.

import SwiftUI
import UIKit
import WorkflowUI
import ReactiveSwift

class PublishedViewController<View: ScreenBackedView>: ScreenViewController<View.Screen> where View.Screen: PublishedScreen {
	private let screenPublisher: ScreenPublisher<View.Screen>
	private let hostingController: UIHostingController<PublishedView<View>>

	// MARK: UIViewController
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		hostingController.view.frame = view.bounds
	}

	// MARK: ScreenViewController
	required init(screen: View.Screen, environment: ViewEnvironment) {
		screenPublisher = .init(screen: screen)
		hostingController = .init(
			rootView: .init(
				view: View(),
				screenPublisher: screenPublisher
			)
		)

		super.init(screen: screen, environment: environment)

		addChild(hostingController)
		view.addSubview(hostingController.view)
		hostingController.didMove(toParent: self)
	}

	override func screenDidChange(from previousScreen: View.Screen, previousEnvironment: ViewEnvironment) {
		super.screenDidChange(from: previousScreen, previousEnvironment: previousEnvironment)
		screenPublisher.screen = screen
	}
}
