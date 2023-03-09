// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import WorkflowUI
import ReactiveKit
import Bond

class ReactiveViewController<View: UIView & Layoutable>: ScreenViewController<View.Screen> {
	private typealias Context = (View.Screen, ViewEnvironment)

	private let context = Subject<Context, Never>()

	private var contentView: View!

	required init(screen: View.Screen, environment: ViewEnvironment) {
		super.init(screen: screen, environment: environment)

		contentView = .init()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		contentView.layout(with: self).layout(in: contentView)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		view.addSubview(contentView)

		NSLayoutConstraint.activate(
			[
				view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
				view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
				view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
				view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
			]
		)
	}

	override func screenDidChange(from previousScreen: View.Screen, previousEnvironment: ViewEnvironment) {
		super.screenDidChange(from: previousScreen, previousEnvironment: previousEnvironment)
		context.send((screen, environment))
	}
}

// MARK: -
extension ReactiveViewController: ScreenProxy {
	subscript<T>(dynamicMember keyPath: KeyPath<View.Screen, T>) -> SafeSignal<T> {
		context
			.map { $0.0[keyPath: keyPath] }
			.prepend(screen[keyPath: keyPath])
	}

	subscript<T>(dynamicMember keyPath: KeyPath<View.Screen, Event<T>>) -> Bond<T> {
		.init(target: self) { base, value in
			base.screen[keyPath: keyPath](value)
		}
	}
}
