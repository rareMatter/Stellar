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
    
	weak
    public
    var value: T?
    
    public
    init(_ value: T) {
		self.value = value
	}
}
