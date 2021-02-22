//
//  AccessoryViewPresentationController.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 2/11/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit

/// Presents a view centered, at less than full container size, with background tap for dismissal.
class AccessoryViewPresentationController: UIPresentationController {
    
    var edgeBufferInsets: UIEdgeInsets {
        
        // Edge buffers, which are applied to the availble safe area bounds before the view is centered (therefore the edges do not need to be even, they are distributed evenly).
        if self.traitCollection.verticalSizeClass == .compact && self.traitCollection.horizontalSizeClass == .compact {
            // Phone in landscape.
            return UIEdgeInsets(top: 16, left: 60, bottom: 0, right: 0)
        }
        else if self.traitCollection.verticalSizeClass == .regular && self.traitCollection.horizontalSizeClass == .compact {
            // Phone in portrait.
            return UIEdgeInsets(top: 60, left: 16, bottom: 0, right: 0)
        }
        else {
            // Sufficient space.
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    var frameBounds: CGRect {
        guard let containerView = self.containerView else { return CGRect() }
        
        var bounds = containerView.bounds.inset(by: containerView.safeAreaInsets)
        let preferredBounds = presentedViewController.preferredContentSize
        
        // Limit size of presented view to it's preferred content size if it is larger.
        if bounds.width > preferredBounds.width {
            bounds.size.width = preferredBounds.width
        }
        if bounds.height > preferredBounds.height {
            bounds.size.height = preferredBounds.height
        }
        
        // Check that edge space is available for background tap dismissal.
        if self.traitCollection.verticalSizeClass == .compact && self.traitCollection.horizontalSizeClass == .compact {
            // Phone in landscape.
            
            let widthEdgeSpace = (containerView.bounds.width - bounds.width) - 60
            
            if widthEdgeSpace < 0 {
                bounds.size.width = bounds.size.width + widthEdgeSpace
            }
            
            let heightEdgeSpace = (containerView.bounds.height - bounds.height) - 16
            
            if heightEdgeSpace < 0 {
                bounds.size.height = bounds.size.height + heightEdgeSpace
            }

        }
        else if self.traitCollection.verticalSizeClass == .regular && self.traitCollection.horizontalSizeClass == .compact {
            // Phone in portrait.
            let widthEdgeSpace = (containerView.bounds.width - bounds.width) - 16
            
            if widthEdgeSpace < 0 {
                bounds.size.width = bounds.size.width + widthEdgeSpace
            }
            
            let heightEdgeSpace = (containerView.bounds.height - bounds.height) - 60
            
            if heightEdgeSpace < 0 {
                bounds.size.height = bounds.size.height + heightEdgeSpace
            }
            
        }
        
        // Place view in center of container.
        bounds.origin.x = containerView.bounds.midX - (bounds.width / 2)
        bounds.origin.y = containerView.bounds.midY - (bounds.height / 2)
        
        return bounds
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return frameBounds
    }
    
    var backgroundView: UIView!
    
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        // Create other needed views here, such as a view for gesture recognition.
        backgroundView = UIView()
        backgroundView.alpha = 0.0
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = backgroundView.bounds
        visualEffectView.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: [.flexibleHeight, .flexibleWidth])
        backgroundView.addSubview(visualEffectView)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(AccessoryViewPresentationController.backgroundViewTapped(tapRecognizer:)))
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
