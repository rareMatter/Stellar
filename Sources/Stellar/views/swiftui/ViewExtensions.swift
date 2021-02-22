//
//  ViewExtensions.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 12/2/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

extension View {
	
	// MARK: - Conditional Modifiers
	
	/// If condition is met, apply modifier, otherwise, leave the view untouched
	public func conditionalModifier<T>(_ condition: Bool, _ modifier: T) -> some View where T: ViewModifier {
		Group {
			if condition {
				self.modifier(modifier)
			} else {
				self
			}
		}
	}
	
	/// Apply trueModifier if condition is met, or falseModifier if not.
	public func conditionalModifier<M1, M2>(_ condition: Bool, _ trueModifier: M1, _ falseModifier: M2) -> some View where M1: ViewModifier, M2: ViewModifier {
		Group {
			if condition {
				self.modifier(trueModifier)
			} else {
				self.modifier(falseModifier)
			}
		}
	}
}
