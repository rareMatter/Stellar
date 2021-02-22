//
//  EdgePanInteractionController.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 8/15/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

final class EdgePanInteractionController: PercentDrivenInteractionController {
	
	// MARK: - Properties
		
	/// The allowed edge for starting the interaction.
	var edge: UIRectEdge = .left
	
	var edgeGesture: UIScreenEdgePanGestureRecognizer!
	
	/// Do not attempt to use this property before the interaction has begun.
	var contextData: UIViewControllerContextTransitioning!
	
	// MARK: - Init
	
	init(edge: UIRectEdge, in view: UIView, delegate: InteractionControllerDelegate, gestureDelegate: UIGestureRecognizerDelegate?) {
		super.init()
		
		self.edge = edge
		self.delegate = delegate
		
		// Create the edge gesture
		self.edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
		self.edgeGesture.edges = edge
		self.edgeGesture.delegate = gestureDelegate
		
		// Add the gesture to the view controller
		view.addGestureRecognizer(edgeGesture)
	}
	
	// MARK: - Interaction
	
	override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
		super.startInteractiveTransition(transitionContext)
		
		self.contextData = transitionContext
	}
	
	@objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
		
		guard let view = gestureRecognizer.view, let container = view.superview else { return }
		
		switch gestureRecognizer.state {
			
		case .began:
			// Update interactive property, then inform delegate the interaction began
			self.isInteracting = true
			delegate.interactionDidBegin(self)
			
			// Set initial translation to compensate for gesture travel in the window's coordinate system. Since the gesture always begins at an edge, this removes any gap that would otherwise exist.
			gestureRecognizer.setTranslation(gestureRecognizer.location(in: nil), in: container)
			
		case .changed:
			guard let toView = contextData.view(forKey: .to) else { return }

			// Get current translation value and velocity
			let translation = gestureRecognizer.translation(in: container)
			let velocity = gestureRecognizer.velocity(in: container)
			
			// Compute how far the gesture traveled, depending on the allowed edges. Check if the gesture should complete the transition if it ends based on translation progress and velocity vector corresponding to presentation edge.
			var progress: CGFloat!
			switch edge {
			case .top:
				progress = translation.y / toView.frame.height
				shouldFinish = progress >= completionThreshold || velocity.y > 0
			case .bottom:
				progress = -(translation.y / toView.frame.height)
				shouldFinish = progress >= completionThreshold || velocity.y < 0
			case .left:
				progress = translation.x / toView.frame.width
				shouldFinish = progress >= completionThreshold || velocity.x > 0
			case .right:
				progress = -(translation.x / toView.frame.width)
				shouldFinish = progress >= completionThreshold || velocity.x < 0
			default:
				break
			}
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
