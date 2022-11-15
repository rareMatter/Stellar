//
//  SlideUpPresentationController.swift
//  Stellar
//
//  Created by Jesse Spencer on 7/26/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

class SlideUpPresentationController: UIPresentationController {
	
	var frameBounds: CGRect {
		guard let containerView = self.containerView else { return CGRect() }
		
		// Inset by safe area
		var bounds = containerView.bounds.inset(by: containerView.safeAreaInsets)
		// Inset by 35, for button-sized area to dismiss
		bounds = bounds.inset(by: UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0))
		
		// Place view starting from bottom edge of container.
		bounds.origin = CGPoint(x: containerView.bounds.origin.x, y: containerView.bounds.maxY - bounds.height)
		
		return bounds
	}
	
	override var frameOfPresentedViewInContainerView: CGRect {
		return frameBounds
	}
	
	var backgroundView: UIView!
	
	
	override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		
		// Create other needed views here, such as a view for gesture recognition.
		
		// Background with visual effect and tap gesture to dismiss
		backgroundView = UIView()
		backgroundView.alpha = 0.0
		
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
		visualEffectView.frame = backgroundView.bounds
		visualEffectView.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: [.flexibleHeight, .flexibleWidth])
		backgroundView.addSubview(visualEffectView)
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped(tapRecognizer:)))
		backgroundView.addGestureRecognizer(tapRecognizer)
	}
	
	// MARK: Presentation controller methods
	
	override func presentationTransitionWillBegin() {
		if let container = self.containerView {
			let presentedViewController = self.presentedViewController
			
			self.backgroundView.frame = container.bounds
			self.backgroundView.alpha = 0.0
			
			container.insertSubview(backgroundView, at: 0)
			presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (coordinatorContext) -> Void in
				self.backgroundView.alpha = 1.0
			}, completion: nil)
		}
	}
	
	override func presentationTransitionDidEnd(_ completed: Bool) {
		if !completed {
			self.backgroundView.removeFromSuperview()
		}
	}
	
	override func dismissalTransitionWillBegin() {
		if let transitionCoordinator = presentedViewController.transitionCoordinator {
			transitionCoordinator.animate(alongsideTransition: { (coordinatorContext) -> Void in
				self.backgroundView.alpha = 0.0
			}, completion: nil)
		}
		else {
			self.backgroundView.alpha = 0.0
		}
	}
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		if completed {
			self.backgroundView.removeFromSuperview()
		}
	}
	
	// MARK: Content container methods
	
	override func containerViewWillLayoutSubviews() {
		
		// Set background view frame.
		if let containerBounds = containerView?.bounds {
			backgroundView.frame = containerBounds
		}
		else {
			debugPrint("Container not set for \(self). Cannot update background view size.")
			backgroundView.frame = CGRect()
		}
		
		presentedView?.frame = frameOfPresentedViewInContainerView
	}
	
	@objc func backgroundViewTapped(tapRecognizer: UITapGestureRecognizer) {
		presentingViewController.dismiss(animated: true, completion: nil)
	}
	
}
