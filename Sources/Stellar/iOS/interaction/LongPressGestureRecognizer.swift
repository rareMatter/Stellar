//
//  LongPressGestureRecognizer.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 9/29/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// A long press gesture recognizer which accepts a closure handler.
final class LongPressGestureRecognizer: UILongPressGestureRecognizer {
	typealias GestureHandler = (UILongPressGestureRecognizer) -> Void
	private let handler: GestureHandler
	
	init(handler: @escaping GestureHandler) {
		self.handler = handler
		super.init(target: nil, action: nil)
		self.addTarget(self, action: #selector(Self.longPressGesture(_:)))
	}
	@objc private
	func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
		handler(gesture)
	}
}

