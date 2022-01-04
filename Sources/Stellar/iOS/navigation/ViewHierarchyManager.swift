//
//  ViewHierarchyManager.swift
//  Stellar
//
//  Created by Jesse Spencer on 3/23/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/// Manages navigation of a view hierarchy in a split view style.
///
/// This class manages navigational architecture in a split view style.
/// - Warning: Modal presentations can fail if the top modal controller is dismissed following the time that a presentation is requested, causing an attempt to perform the presentation on the dismissed controller. The only exception to this is attempted presentations on UIAlertControllers.
public
final
class ViewHierarchyManager: NSObject {

    // MARK: - properties
    
    /// A dictionary of generated view data that currently exists in the hierarchy. The keys are view IDs and values are the generated data.
    ///
    /// This is used to associate generated view data with the view which produced it.
    private
    var presentedViews: [UUID : PresentationData] = [:]
    
	// -- primary column
	
	/// The controller installed as the `PresentationStyle.root` of the primary column.
	private var primaryRootViewController: UIViewController?
	
	// -- secondary column
	
	/// The stack of controllers in the content column, including the root controller.
	private var contentViewControllers = [UIViewController]()

	// -- modal
	
	/// The modal presentation stack.
	private var modalViewControllers = [UIViewController]()
	/// Returns the top active view controller, suitable as the root for modal presentation.
	private var topModalController: UIViewController {
		if let top = modalViewControllers.last {
			return top
		}
		else {
			return splitViewController
		}
	}
    
	// -- modal deferrment
	/// Data necessary to perform a deferred modal presentation. If this property exists, a modal presentation needs to be performed.
	private var deferredModalPresentationData: PresentationData?
	
	// -- embedded controllers
	private let splitViewController: SSplitViewController
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
		
		// Add nav views to split view
		splitViewController.setViewController(primaryNavigationController, for: .primary)
		splitViewController.setViewController(primaryNavigationController, for: .compact)
		splitViewController.setViewController(contentNavigationController, for: .secondary)
	}
}

// MARK: - presentation
private
extension
ViewHierarchyManager {
	
    /// Use this method as an entry-point passthrough for the matching API method.
    ///
    /// - Note: This method enforces main queue execution.
    func _go(to view: SView, withRoute route: SDestinationRoute, atLocation location: SDestinationLocation, withAnimation animated: Bool) {
        dispatchPrecondition(condition: .onQueue(.main))

        // Create data
        let data = PresentationData(route: route,
                                    location: location,
                                    controller: view.content,
                                    animated: animated)
        
        let didPresent = performPresentationOf(data)

        // Cache the presentation data
        if didPresent {
            // associate data with view ID after a successful presentation
            assert(!presentedViews.keys.contains(view.id), "Attempt to go to a view with a non-unique ID. This is not allowed. Provided view: \(view). Existing view: \(presentedViews[view.id]!)")
            presentedViews[view.id] = data
            
            // connect to dismissal publisher and update state if presentation was successful
            connectToDismissalPublisherFor(viewID: view.id, with: data)
        }
    }
    
	/// Presents the provided controller on the screen using an appropriate method specified by view properties.
	/// - Note: At times it may be necessary for this method to defer the presentation for some amount of time.
	/// - Return: Whether or not the presentation was successful. A successful presentation does not mean immediate display on screen but rather the receiver has successfully processed the presentation as needed.
	@discardableResult
    func performPresentationOf(_ presentationData: PresentationData) -> Bool {

        var wasSuccessful = false
        if presentationData.location == .modal {
            wasSuccessful = showModal(presentationData)
		}
		else {
            switch presentationData.route {
				case .primary:
                    wasSuccessful = showPrimary(viewController: presentationData.controller, at: presentationData.location, withAnimation: presentationData.animated)

				case .secondary:
                    wasSuccessful = showContent(viewController: presentationData.controller, at: presentationData.location, withAnimation: presentationData.animated)
			}
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
	func showContent(viewController: ViewHierarchyObject, at location: SDestinationLocation, withAnimation animated: Bool) -> Bool {
		
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
    func showModal(_ data: PresentationData) -> Bool {
		// check for deferral
		if modalPresentationNeedsDeferment(data) {
			self.deferredModalPresentationData = data
		}
		else {
			// perform presentation
            let completionHandler = onModalPresentation(of: data.controller)
            topModalController.present(data.controller, animated: data.animated, completion: completionHandler)
		}
		
		return true
	}
}

// MARK: - dismissal
private
extension
ViewHierarchyManager {
	
    /// Dismisses the view if a corresponding, generated view controller instance currently exists in the hierarchy.
    ///
    /// Use this method an entry-point passthrough for the matching API method.
    /// - Note: This method enforces main queue execution.
    func _dismiss(_ view: SView, withAnimation animated: Bool) {
        dispatchPrecondition(condition: .onQueue(.main))
        if let presentationData = presentedViews[view.id] {
            presentationData
                .controller
                .dismissFromHierarchy(withAnimation: animated)
        }
    }
    
    /// Connects to the dismissal publisher of the view controller corresponding to `id` in `presentedViews`.
    func connectToDismissalPublisherFor(viewID: UUID, with presentationData: PresentationData) {
        presentationData
            .controller
            .dismissalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] viewController in
                self.handleDismissalOfView(viewID, with: presentationData)
            }
            .store(in: &cancellables)
    }
    
    /// Handles necessary cleanup and deferred modal presentations after dismissal of a view controller.
    func handleDismissalOfView(_ viewID: UUID, with presentationData: PresentationData) {
        // update the caches
        self.purgeCacheIfNeededOf(presentationData.controller)
        self.presentedViews[viewID] = nil
        
        // perform any deferred presentations only after a controller has dismissed.
        self.performDeferredModalPresentationIfNeeded()
    }
	
	/// Walks the hierarchy caches and removes the controller, if found. This is not a dismissal method but for housekeeping.
	func purgeCacheIfNeededOf(_ viewController: UIViewController) {
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
ViewHierarchyManager {
	
	/// Determines whether a modal presentation can take place now. If not, this method returns data to use for deferring the presentation.
	///
	/// - Returns: Data to use for deferring the modal presentation, if needed. Returns nil if the presentation can be performed now.
	private
    func modalPresentationNeedsDeferment(_ data: PresentationData) -> Bool {
		if topModalController is UIAlertController {
            return true
		}
		else {
			return false
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
        let success = showModal(cache)
		if success { deferredModalPresentationData = nil }
	}
}

// MARK: - presentation data
/// Data for a view that has been added to the hierarchy.
private
struct PresentationData {
    let route: SDestinationRoute
    let location: SDestinationLocation
    let controller: ViewHierarchyObject
    let animated: Bool
}

// MARK: - api
extension ViewHierarchyManager {
	
	var rootViewController: ViewHierarchyObject {
		splitViewController
	}
	
    func containsView(_ view: SView) -> Bool {
        presentedViews[view.id] != nil
    }
    
    /// Places the view into the hierarchy and on screen.
    /// - Parameters:
    ///   - destinationView: The view to show.
    ///   - animated: Whether to animate the transition.
    func go(to view: SView, withRoute route: SDestinationRoute, atLocation location: SDestinationLocation, withAnimation animated: Bool) {
        _go(to: view,
            withRoute: route,
            atLocation: location,
            withAnimation: animated)
    }
    
    /// Removes the view from the screen and hierarchy.
    /// - Parameters:
    ///   - view: The view to remove.
    ///   - animated: Whether to animate the transition.
    func dismiss(_ view: SView, withAnimation animated: Bool) {
        _dismiss(view, withAnimation: animated)
    }
}
