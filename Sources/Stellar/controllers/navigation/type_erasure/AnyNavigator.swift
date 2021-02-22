//
//  AnyNavigator.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 12/11/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

/// A type-erasing Navigator object.
public
struct AnyNavigator<D>: Navigator {
	
	private let goHandler: (_ destination: D, _ animated: Bool) -> Void
	
	init<N: Navigator>(erasing navigator: N) where N.Destination == D {
		self.goHandler = { destination, animated in
			navigator.go(to: destination, withAnimation: animated)
		}
	}
	
    public
	typealias Destination = D
	
    public
	func go(to destination: Destination, withAnimation: Bool = true) {
		goHandler(destination, withAnimation)
	}
}
