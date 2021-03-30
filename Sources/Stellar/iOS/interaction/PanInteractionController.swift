//
//  PanInteractionController.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 8/12/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//
// Created with reference to:
//

import UIKit

enum PanDirection {
	case left, right, up, down
}

final class PanInteractionController: PercentDrivenInteractionController {
	
	// MARK: - Properties
		
	/// The allowed axis for beginning the interaction.
	var panDirection: PanDirection = .left
	
	/// The pan gesture used for updating progress of the interaction.
	var panGesture: UIPanGestureRecognizer!
	
	/// Used to determine if the velocity has changed since the previous gesture change.
	var previousVelocity: CGPoint!
	
	// MARK: - Init
	
	init(panDirection: PanDirection, in view: UIView, delegate: InteractionControllerDelegate, gestureDelegate: UIGestureRecognizerDelegate?) {
		super.init()
		
		self.panDirection = panDirection
		self.delegate = delegate
		
		// Create the pan gesture
		self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
		self.panGesture.maximumNumberOfTouches = 1
		self.panGesture.delegate = gestureDelegate
		
		// Add the gesture to the view controller
		view.addGestureRecognizer(panGesture)
	}
	
	// MARK: - Interaction
	
	@objc func handleGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
		
		guard let view = panGestureRecognizer.view, let container = view.superview else { return }
				
		switch panGestureRecognizer.state {
			
		case .began:
			// Update interactive property, then inform delegate the interaction began
			self.isInteracting = true
			delegate.interactionDidBegin(self)
			
			panGestureRecognizer.setTranslation(CGPoint.zero, in: container)
			// Init previous velocity
			previousVelocity = panGestureRecognizer.velocity(in: container)
			
		case .changed:
			// If the velocity changes polarity and progress is zero, set the translation to zero. (This allows for an initially incorrect pan to become correct during it's tracking. i.e. the user has begun dragging in the wrong direction, causing the translation to be tracked at that initial spot, then changes to a correct direction far from the initial translation coordinate. The user then has to pan all the way past the initial spot to cause any progress.)
			let velocity = panGestureRecognizer.velocity(in: container)
			if percentComplete == 0 {
				switch panDirection {
				case .up, .down:
					if previousVelocity.y.sign != velocity.y.sign {
						panGestureRecognizer.setTranslation(CGPoint.zero, in: container)
					}
				case .left, .right:
					if previousVelocity.x.sign != velocity.x.sign {
						panGestureRecognizer.setTranslation(CGPoint.zero, in: container)
					}
				}
			}
			// Update previous velocity
			previousVelocity = velocity
			
			// Get current translation value
			let translation = self.panGesture.translation(in: container)
			
			// Compute how far the gesture traveled. Depending on the pan direction, flip polarity to allow progress only in that direction.
			var progress: CGFloat!
			switch panDirection {
			case .up:
				progress = -(translation.y / container.bounds.height)
				shouldFinish = progress >= completionThreshold || velocity.y < 0
			case .down:
				progress = translation.y / container.bounds.height
				shouldFinish = progress >= completionThreshold || velocity.y > 0
			case .left:
				progress = -(translation.x / container.bounds.width)
				shouldFinish = progress >= completionThreshold || velocity.x < 0
			case .right:
				progress = translation.x / container.bounds.width
				shouldFinish = progress >= completionThreshold || velocity.x > 0
			}
			// Constrain progress to be between 0 and 1.
			progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
			
			// Use the translation value to update the interactive animator
			update(progress)
			
		case .cancelled:
			self.isInteracting = false
			cancel()
			
		case .ended:
			self.isInteracting = false
						
			if shouldFinish {
				finish()
			} else {
				cancel()
			}
			
		default:
			break
		}
	}
			
}
