//
//  SlideOverAnimationController.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 8/11/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//
// Created with reference to:
// https://www.raywenderlich.com/3636807-uipresentationcontroller-tutorial-getting-started#toc-anchor-010

import UIKit

final class SlideOverAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
	
	// MARK: - Properties
	
	let direction: PresentationDirection
	
	let isPresentation: Bool
	
	var percentDrivenInteractionController: PercentDrivenInteractionController!
	
	// MARK: - Init
	
	init(direction: PresentationDirection, isPresentation: Bool, percentDrivenInteractionController: PercentDrivenInteractionController) {
		self.direction = direction
		self.isPresentation = isPresentation
		self.percentDrivenInteractionController = percentDrivenInteractionController
		
		super.init()
	}
	
	// MARK: - Animation
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.15
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		if !transitionContext.isAnimated { return }
		
		let vcKey: UITransitionContextViewControllerKey = isPresentation ? .to : .from
		
		guard let controller = transitionContext.viewController(forKey: vcKey) else { return }
		
		if isPresentation {
			transitionContext.containerView.addSubview(controller.view)
		}
		
		let presentedFrame = transitionContext.finalFrame(for: controller)
		var dismissedFrame = presentedFrame
		
		switch direction {
		case .left:
			dismissedFrame.origin.x = -presentedFrame.width
		case .right:
			dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
		case .top:
			dismissedFrame.origin.y = -presentedFrame.height
		case .bottom:
			dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
		}
		
		let initialFrame = isPresentation ? dismissedFrame : presentedFrame
		let finalFrame = isPresentation ? presentedFrame : dismissedFrame
		
		let duration = transitionDuration(using: transitionContext)
		
		controller.view.frame = initialFrame
		
		// TODO: Use keyframes, which decide the timing of the animation. Relative start time must be in the range 0 to 1, relative to the full animation duration. Relative duration must be in the range 0 to 1, also relative to the full animation duration.
		UIView.animate(
			withDuration: duration,
			delay: 0,
			options: .curveLinear,
			animations: {
				controller.view.frame = finalFrame
		},
		completion: { (completed) in
			let success = !transitionContext.transitionWasCancelled
			// After a failed presentation or successful dismissal, remove the view
			if self.isPresentation && !success || !self.isPresentation && success {
				controller.view.removeFromSuperview()
			}
			
			transitionContext.completeTransition(success)
		})
	}
}
