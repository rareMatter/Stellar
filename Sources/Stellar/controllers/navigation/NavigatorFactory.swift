//
//  NavigatorFactory.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 12/11/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

/// A factory which produces type-erased Navigators with a particular destination scope.
public
protocol NavigatorFactory {
	func makeNavigator() -> AnyNavigator<NLDestination>
}
/// navigator factory which type erases the navigator
public
struct NLNavigatorFactory: NavigatorFactory {
	
	let hierarchyManager: HierarchyManager
	
    public init(hierarchyManager: HierarchyManager) {
        self.hierarchyManager = hierarchyManager
    }
    
    public
	func makeNavigator() -> AnyNavigator<NLDestination> {
		.init(erasing: NLNavigator(hierarchyManager: hierarchyManager))
	}
}
