//
//  UIViewController+Extensions.swift
//  Stellar
//
//  Created by Jesse Spencer on 9/30/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - presentation
#warning("TODO: this should probably be internal.")
public
extension UIViewController {
	
	/// Dismisses the view controller from the hierarchy regardless of how it was presented.
	func dismissFromHierarchy(withAnimation animated: Bool = true) {
		if presentingViewController != nil {
			dismiss(animated: animated, completion: nil)
		}
		else if let navigationController = navigationController {
			let updatedViewControllers = navigationController.viewControllers.filter { $0 != self }
			navigationController.setViewControllers(updatedViewControllers, animated: animated)
		}
		else {
			assertionFailure("Unhandled container dismissal case.")
			return
		}
	}
}

// MARK: - Embedding views
#warning("TODO: this should probably be internal.")
public
extension UIViewController {
	/// Adds a view as the root subview of the receiver.
	func embedView(_ view: UIView) {
		guard let rootView = viewIfLoaded else {
			assertionFailure("Attempt to embed a view before the root view is loaded.")
			return
		}
		rootView.addSubview(view)
		view.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}
