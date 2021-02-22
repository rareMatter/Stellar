//
//  NLNavigator.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 11/29/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

public
struct NLNavigator: Navigator {
	// TODO: HierarchyManager is a protocol which defines a navigation abstraction on top of UIKit. Instead of depending on it here, in the implementation of a Navigator (the generalized navigation pattern definition within the NL framework), this object should be provided to a UIKit object as a model to observe for navigation command interface.
	let hierarchyManager: HierarchyManager
	
    public
	typealias Destination = NLDestination
	
    public
    init(hierarchyManager: HierarchyManager) {
        self.hierarchyManager = hierarchyManager
    }
    
    public
	func go(to destination: Destination, withAnimation: Bool = true) {
		let presentation = destination.makePresentationData()
		
		hierarchyManager.show(viewController: presentation.viewController, inContext: presentation.presentationContext, withStyle: presentation.presentationStyle, withAnimation: withAnimation)
	}
}
