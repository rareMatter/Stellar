//
//  SView.swift
//  
//
//  Created by Jesse Spencer on 2/23/21.
//

import Foundation

/// The description of view content.
public
protocol SView {
    
    var id: UUID { get set }
    
    var content: ViewHierarchyObject { get }
}

// MARK: - navigation
public
extension SView {
    
    /// Navigates to `destination` using the `route` and `location`.
    /// - Parameters:
    ///   - destination: The view which will be shown.
    ///   - route: The route to take when showing `destination` or nil to use current context.
    ///   - location: The location to use when showing `destination` or nil to use current context.
    func go(to destination: SView, withRoute route: SDestinationRoute, atLocation location: SDestinationLocation, withAnimation animated: Bool = true) {
        appDelegate
            .go(to: destination,
                from: self,
                withRoute: route,
                atLocation: location,
                withAnimation: animated)
    }
    
    /// Dismisses the topmost view which has been shown using `go(to:)`.
    func dismiss(_ view: SView, withAnimation animated: Bool = true) {
        appDelegate
            .dismiss(view, withAnimation: animated)
    }
}
