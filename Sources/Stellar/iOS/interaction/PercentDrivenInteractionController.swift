//
//  PercentDrivenInteractionController.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 8/15/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

protocol InteractionControllerDelegate: AnyObject {
	func interactionDidBegin(_ interactionController: PercentDrivenInteractionController)
}

/// A subclass of UIPercentDrivenInteractiveTransition which adds properties for use by a transitioning delegate when vending objects.
class PercentDrivenInteractionController: UIPercentDrivenInteractiveTransition {
	
	let completionThreshold: CGFloat = 0.5
	
	var isInteracting = false
	var shouldFinish = false
	
	weak var delegate: InteractionControllerDelegate!
	
	override init() {
		super.init()
		
		completionSpeed = 0.4
	}
	
}
