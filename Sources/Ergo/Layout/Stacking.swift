// Copyright © Fleuronic LLC. All rights reserved.

import UIKit
import Layoutless

import enum Metric.Spacing

public protocol Stacking: Layoutable {
	static var verticalSpacing: Spacing.Vertical { get }

	@VerticallyStacked<Self> func content(screen: some ScreenProxy<Screen>) -> Layout<UIStackView>
}

// MARK: -
public extension Stacking {
	static var verticalSpacing: Spacing.Vertical { .zero }

	func layout(with screen: some ScreenProxy<Screen>) -> AnyLayout {
		content(screen: screen).fillingParent()
	}
}

// MARK: -
@resultBuilder public struct VerticallyStacked<T: Stacking> {
	public static func buildBlock(_ layouts: AnyLayout?...) -> Layout<UIStackView> {
		stack(
			layouts.compactMap { $0 },
			axis: .vertical,
			spacing: T.verticalSpacing.value,
			distribution: .fill,
			alignment: .fill,
			configure: { _ in }
		)
	}
}
