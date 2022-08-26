// Copyright © Fleuronic LLC. All rights reserved.

import struct ReactiveKit.SafeSignal
import struct Bond.Bond
import protocol WorkflowUI.Screen

@dynamicMemberLookup public protocol ScreenProxy<Screen> {
	associatedtype Screen: WorkflowUI.Screen

	subscript<T>(dynamicMember keyPath: KeyPath<Screen, T>) -> SafeSignal<T> { get }
	subscript<T>(dynamicMember keyPath: KeyPath<Screen, Event<T>>) -> Bond<T> { get }
}
