//
//  InteractionStyle.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/19/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

enum InteractionStyle: Hashable {
	case none(view: UIView)
	case button(primaryAction: UIAction, image: UIImage)
	
	static func == (lhs: InteractionStyle, rhs: InteractionStyle) -> Bool {
		switch lhs {
			case let .none(view):
				if case let .none(otherView) = rhs {
					return view == otherView
				}
			case let .button(primaryAction, primaryImage):
				switch rhs {
					case let .button(otherPrimaryAction, otherImage):
						return primaryAction == otherPrimaryAction &&
							primaryImage == otherImage
					default:
						break
				}
		}
		return false
	}
	func hash(into hasher: inout Hasher) {
		switch self {
			case let .button(primaryAction, image):
				hasher.combine(primaryAction)
				hasher.combine(image)
			case let .none(view):
				hasher.combine(view)
		}
	}
}
