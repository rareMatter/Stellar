//
//  SView.swift
//  
//
//  Created by Jesse Spencer on 2/23/21.
//

import Foundation

/// The basis for describing view content and how it should be navigated to.
public
protocol SView {
    var content: ViewHierarchyObject { get }
    
    var route: SDestinationRoute { get set }
    var location: SDestinationLocation { get set }
}

// MARK: - navigation
public
extension SView {
    
    /// Navigates to `destination` using the `route` and `location`.
    /// - Parameters:
    ///   - destination: The view which will be shown.
    ///   - route: The route to take when showing `destination` or nil to use current context.
    ///   - location: The location to use when showing `destination` or nil to use current context.
    func go(to destination: ViewHierarchyObject, with route: SDestinationRoute? = nil, at location: SDestinationLocation? = nil) {
        let route = route ?? self.route
        let location = location ?? self.location
        content.rootController
            .show(viewController: destination,
                  with: route,
                  at: location,
                  withAnimation: true)
    }
    
    /// A default value of `primary` which cannot be set unless implemented.
    var route: SDestinationRoute {
        get { .primary }
        set {}
    }
    /// A default value of `modal` which cannot be set unless implemented.
    var location: SDestinationLocation {
        get { .modal }
        set {}
    }
}
