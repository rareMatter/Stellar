//
//  WeakStorage.swift
//  Stellar
//
//  Created by Jesse Spencer on 11/6/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

public
final
class Weak<T: AnyObject> {
	weak var value: T?
	init(value: T) {
		self.value = value
	}
	static func weak<T: AnyObject>(_ value: T) -> Weak<T> {
		.init(value: value)
	}
}
