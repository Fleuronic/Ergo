// Copyright © Fleuronic LLC. All rights reserved.

import enum Metric.Spacing
import class UIKit.UIStackView
import struct Layoutless.Layout
import func Layoutless.stack
import protocol Layoutless.AnyLayout

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
