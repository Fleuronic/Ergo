// Copyright © Fleuronic LLC. All rights reserved.

import WorkflowUI
import ReactiveSwift

@dynamicMemberLookup public protocol ScreenProxy<Screen> {
	associatedtype Screen: WorkflowUI.Screen

	subscript<T>(dynamicMember keyPath: KeyPath<Screen, T>) -> Property<T> { get }
	subscript<T>(dynamicMember keyPath: KeyPath<Screen, T>) -> Property<T?> { get }
	subscript(dynamicMember keyPath: KeyPath<Screen, () -> Void>) -> BindingTarget<Void> { get }
	subscript<T>(dynamicMember keyPath: KeyPath<Screen, (T) -> Void>) -> BindingTarget<T> { get }
}
