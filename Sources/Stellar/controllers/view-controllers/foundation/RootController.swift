//
//  RootController.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 3/23/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/// Manages root navigational architecture using a split view controller.
///
/// This class provides API for interacting with the root navigational architecture. Generally, it is a simplification of UISplitViewController.
/// - Warning: Modal presentations can fail if the top modal controller is dismissed following the time that a presentation is requested, causing an attempt to perform the presentation on the dismissed controller. The only exception to this is attempted presentations on UIAlertControllers.
public
final
class RootController: NSObject {

	// MARK: - primary column
	
	/// The controller installed as the `PresentationStyle.root` of the primary column.
	private var primaryRootViewController: UIViewController?
	
	// MARK: - secondary column
	
	/// The stack of controllers in the content column, including the root controller.
	private var contentViewControllers = [UIViewController]()

	// MARK: - modal
	
	/// The modal presentation stack.
	private var modalViewControllers = [UIViewController]()
	/// Returns the top active view controller, suitable as the root for modal presentation.
	private var topViewController: UIViewController {
		if let top = modalViewControllers.last {
			return top
		}
		else {
			return splitViewController
		}
	}
	
	// MARK: - modal deferrment
	/// Data necessary to perform a deferred modal presentation. If this property exists, a modal presentation needs to be performed.
	private var deferredModalPresentationData: DeferredModalPresentationData?
	
	// MARK: - embedded controllers
	private let splitViewController: UISplitViewController
	private let primaryNavigationController: NLNavigationController
	private let contentNavigationController: NLNavigationController
	
	// subscription tokens
	private var cancellables = [AnyCancellable]()
	
	// MARK: - init
	override init() {
		self.splitViewController = .init(style: .doubleColumn)
		self.primaryNavigationController = .init(nibName: nil, bundle: nil)
		self.contentNavigationController = .init(nibName: nil, bundle: nil)

		super.init()
		
		splitViewController.delegate = self
		primaryNavigationController.delegate = self
		contentNavigationController.delegate = self

		// Add nav views to split view
		splitViewController.setViewController(primaryNavigationController, for: .primary)
		splitViewController.setViewController(primaryNavigationController, for: .compact)
		splitViewController.setViewController(contentNavigationController, for: .secondary)
	}
}

// MARK: - presentation
private
extension
RootController {
	
	/// Presents the provided controller.
	/// - Note: At times it may be necessary for this method to defer the presentation for some amount of time.
	/// - Return: Whether or not the presentation was successful. A successful presentation does not mean immediate display on screen but rather the receiver has successfully processed the presentation as needed.
	@discardableResult
    func performPresentationOf(_ viewController: ViewHierarchyObject, with route: SDestinationRoute, at location: SDestinationLocation, withAnimation animated: Bool) -> Bool {
		dispatchPrecondition(condition: .onQueue(.main))
		
		var wasSuccessful = false
		if location == .modal {
			wasSuccessful = showModal(viewController, withAnimation: animated)
		}
		else {
			switch route {
				case .primary:
					wasSuccessful = showPrimary(viewController: viewController, at: location, withAnimation: animated)

				case .secondary:
					wasSuccessful = showContent(viewController: viewController, at: location, withAnimation: animated)
			}
		}
		
		// connect to dismissal publisher and update state if presentation was successful
		if wasSuccessful {
			connectToDismissalPublisherFor(viewController)
            viewController.rootController = self
		}
		return wasSuccessful
	}
	
	/// Shows the view controller in the primary column.
	///
	/// - Warning: This method only supports `root` `PresentationStyle`. If a different one is provided, an assertion is thrown.
	func showPrimary(viewController: UIViewController & ViewHierarchyObject, at location: SDestinationLocation, withAnimation animated: Bool) -> Bool {

		switch location {
			case .root:
				primaryNavigationController.setViewControllers([viewController], animated: animated)
				primaryRootViewController = viewController
				return true
				
			case .stack:
				assertionFailure("\(#function) : \(location) is not supported for the primary column. Use content column instead.")
				
			default:
				assertionFailure("Unexpected style passed to \(#function): \(location).")
		}
		
		return false
	}
	
	/// Shows the view controller as a content view, alongside the primary column.
	/// - Note: If the root controller is collapsed this method will stack content onto the primary view. This means the `root` `PresentationStyle` will have the same effect as `stack`, only while the root controller is collapsed.
	func showContent(viewController: UIViewController & ViewHierarchyObject, at location: SDestinationLocation, withAnimation animated: Bool) -> Bool {
		
		switch location {
			case .root:
				contentViewControllers.insert(viewController, at: 0)
				
				if splitViewController.isCollapsed {
					let updatedViewControllers = Array([primaryRootViewController] + contentViewControllers).compactMap { $0 }
					primaryNavigationController.setViewControllers(updatedViewControllers, animated: animated)
				}
				else {
					contentNavigationController.setViewControllers(contentViewControllers, animated: animated)
				}
				
				return true
				
			case .stack:
				contentViewControllers.append(viewController)
				
				if splitViewController.isCollapsed {
					primaryNavigationController.pushViewController(viewController, animated: animated)
				}
				else {
					contentNavigationController.pushViewController(viewController, animated: animated)
				}
				
				return true
				
			default:
				assertionFailure("Unexpected style passed to \(#function): \(location).")
		}
		
		return false
	}
	
	/// Performs a modal presentation.
	///
	/// - Returns:
	func showModal(_ viewController: UIViewController & ViewHierarchyObject, withAnimation animated: Bool) -> Bool {
		// check for deferral
		if let deferredModalData = deferModalPresentationIfNeeded(viewController: viewController, withAnimation: animated) {
			self.deferredModalPresentationData = deferredModalData
		}
		else {
			// perform presentation
			let completionHandler = onModalPresentation(of: viewController)
			topViewController.present(viewController, animated: animated, completion: completionHandler)
		}
		
		return true
	}
}

// MARK: - caching
private
extension
RootController {
	
	/// Connects to the dismissal publisher of the controller to perform cache updates upon receiving updates.
	private func connectToDismissalPublisherFor(_ viewController: UIViewController & ViewHierarchyObject) {
		viewController.dismissalPublisher
			.receive(on: DispatchQueue.main)
			.sink { [unowned self] viewController in
				// this method must be called to update the caches.
				self.purgeCacheIfNeededOf(viewController)
				
				// perform any deferred presentations only after a controller has dismissed.
				self.performDeferredModalPresentationIfNeeded()
			}
			.store(in: &cancellables)
	}
	
	/// Walks the hierarchy caches and removes the controller, if found. This is not a dismissal method but for housekeeping. Therefore this method should only be called from the dismissal subject handler.
	private func purgeCacheIfNeededOf(_ viewController: UIViewController) {
		// walk the hierarchy from each root controller and remove viewController if found.
		if let primaryRoot = primaryRootViewController,
		   primaryRoot === viewController {
			primaryRootViewController = nil
		}
		else if let index = contentViewControllers.firstIndex(of: viewController) {
			contentViewControllers.remove(at: index)
		}
		else if let index = modalViewControllers.firstIndex(of: viewController) {
			modalViewControllers.remove(at: index)
		}
		else {
			debugPrint("\(self): Attempt to remove a view controller from the cache which is not present: \(viewController)")
		}
	}
}

// MARK: - modal deferment
private
extension
RootController {
	
    private
	struct DeferredModalPresentationData {
		var viewController: UIViewController & ViewHierarchyObject
		var animated: Bool
	}
	
	/// Determines whether a modal presentation can take place now. If not, this method returns data to use for deferring the presentation.
	///
	/// - Returns: Data to use for deferring the modal presentation, if needed. Returns nil if the presentation can be performed now.
	private
    func deferModalPresentationIfNeeded(viewController: UIViewController & ViewHierarchyObject, withAnimation animated: Bool) -> DeferredModalPresentationData? {
		if topViewController is UIAlertController {
			return .init(viewController: viewController, animated: animated)
		}
		else {
			return nil
		}
	}
	
	/// Creates a closure which updates the cache as needed.
	func onModalPresentation(of viewController: UIViewController) -> () -> Void {
		{ [unowned self] in
			self.modalViewControllers.append(viewController)
		}
	}
	
	/// If a modal presentation was aborted and the cached data exists, this method will perform a modal presentation.
	func performDeferredModalPresentationIfNeeded() {
		guard let cache = deferredModalPresentationData else { return }
		let success = showModal(cache.viewController, withAnimation: cache.animated)
		if success {
			deferredModalPresentationData = nil
		}
	}
}

// MARK: - UISplitViewDelegate
extension RootController: UISplitViewControllerDelegate {
	
}
// MARK: - UINavigationControllerDelegate
extension RootController: UINavigationControllerDelegate {
	
}

// MARK: - api
extension RootController {
	
	var rootViewController: UIViewController {
		splitViewController
	}
	
    func show(viewController: UIViewController & ViewHierarchyObject, with route: SDestinationRoute, at location: SDestinationLocation, withAnimation isAnimated: Bool) {
        performPresentationOf(viewController, with: route, at: location, withAnimation: isAnimated)
	}
	
	/// Dismisses the view controller if it is currently in the navigation hierarchy.
	func dismissControllerIfNeeded(_ viewController: UIViewController, withAnimation: Bool = true) {
        dispatchPrecondition(condition: .onQueue(.main))
		
		if let index = primaryNavigationController.viewControllers.firstIndex(of: viewController) {
			var updatedViewControllers = primaryNavigationController.viewControllers
			updatedViewControllers.remove(at: index)
			primaryNavigationController.setViewControllers(updatedViewControllers, animated: withAnimation)
		}
		else if let index = contentNavigationController.viewControllers.firstIndex(of: viewController) {
			var updatedViewControllers = contentNavigationController.viewControllers
			updatedViewControllers.remove(at: index)
			contentNavigationController.setViewControllers(updatedViewControllers, animated: withAnimation)
		}
		else {
			// -- warning --
			// If any container controller is embedded in the presentation chain which is then used to present modally, this will break the chain as checked below. A check of each presented controller for the content controller type, navigation, tab, etc., would be necessary to continue following the presentation chain.
			
			// check primary chain
			var presented = primaryNavigationController.presentedViewController
			while presented?.presentedViewController != nil {
				presented = presented?.presentedViewController
			}
			presented?.dismiss(animated: withAnimation, completion: nil)
			
			// check content chain
			presented = contentNavigationController.presentedViewController
			while presented?.presentedViewController != nil {
				presented = presented?.presentedViewController
			}
			presented?.dismiss(animated: withAnimation, completion: nil)
		}
	}
}
