//
//  SetExtensions.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 8/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

extension Set {
	/// Returns a new instance with the element toggled by inserting, if not present, or removing, if present, in the set.
	func toggling(element: Element) -> Self {
		var receiver = self
		if let _ = receiver.remove(element) {
			return receiver
		}
		else {
			receiver.insert(element)
			return receiver
		}
	}
	
	/// Toggles the element by inserting, if not present, or removing, if present, in the set.
	mutating func toggle(_ element: Element) {
		if let _ = self.remove(element) {}
		else {
			self.insert(element)
		}
	}
}
