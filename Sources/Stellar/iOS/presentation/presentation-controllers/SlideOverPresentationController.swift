//
//  SlideOverPresentationController.swift
//  Stellar
//
//  Created by Jesse Spencer on 8/3/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//
// Created with reference to:
// https://www.raywenderlich.com/3636807-uipresentationcontroller-tutorial-getting-started#toc-anchor-004

import UIKit

enum PresentationDirection {
	case left, right, bottom, top
}

class SlideOverPresentationController: UIPresentationController {
	
	// MARK: Properties
	
	var direction: PresentationDirection = .left
	
	override var frameOfPresentedViewInContainerView: CGRect {
		var frame: CGRect = .zero
		frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
		
		switch direction {
		case .right:
			frame.origin.x = containerView!.frame.width * (0.5/10.0)
		case .bottom:
			frame.origin.y = containerView!.frame.height * (0.5/10.0)
		default:
			frame.origin = .zero
		}
		
		return frame
	}
		
	private var backgroundView: UIView!
	
	
	// MARK: Init
	
	init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		
		self.direction = direction
		
		setupDimmingView()
	}
	
	
	// MARK: Presentation controller methods
	
	override func presentationTransitionWillBegin() {
		guard let backgroundView = backgroundView, let container = containerView else {
			return
		}
		
		container.insertSubview(backgroundView, at: 0)
		
		backgroundView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
		backgroundView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
		backgroundView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
		backgroundView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
		
		guard let coordinator = presentedViewController.transitionCoordinator else {
			backgroundView.alpha = 1.0
			return
		}
		
		coordinator.animate(alongsideTransition: { _ in
			self.backgroundView.alpha = 1.0
		})
	}
	
	override func presentationTransitionDidEnd(_ completed: Bool) {
		if !completed {
			self.backgroundView.removeFromSuperview()
		}
	}
	
	override func dismissalTransitionWillBegin() {
		guard let coordinator = presentedViewController.transitionCoordinator else {
			backgroundView.alpha = 0.0
			return
		}
		
		coordinator.animate(alongsideTransition: { _ in
			self.backgroundView.alpha = 0.0
		})
	}
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		if completed {
			self.backgroundView.removeFromSuperview()
		}
	}
	
	// MARK: Content container methods
	
	override func containerViewWillLayoutSubviews() {
		presentedView?.frame = frameOfPresentedViewInContainerView
	}
	
	override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
		switch direction {
		case .left, .right:
			return CGSize(width: parentSize.width * (9.5/10.0), height: parentSize.height)
//			return CGSize(width: parentSize.width, height: parentSize.height)
		case .bottom, .top:
			return CGSize(width: parentSize.width, height: parentSize.height * (9.5/10.0))
		}
	}
	
}
// MARK: Background view
extension SlideOverPresentationController {
	
	func setupDimmingView() {
		backgroundView = UIView()
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
		backgroundView.alpha = 0.0
		
		// Create tap recognizer
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backgroundViewTapped(tapRecognizer:)))
		backgroundView.addGestureRecognizer(tapRecognizer)
	}
	
	@objc func backgroundViewTapped(tapRecognizer: UITapGestureRecognizer) {
		presentedViewController.dismiss(animated: true, completion: nil)
	}
		
}
