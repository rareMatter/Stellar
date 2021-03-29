//
//  SWindowSceneDelegate.swift
//  
//
//  Created by Jesse Spencer on 3/22/21.
//

import UIKit

/// A singleton object which manages all SWindow instances.
final
class SWindowSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    /// A primary window provided by SAppDelegate.
    static
    var primarySWindow: AnySWindow!
    
    /// The controller associated with the primary window.
    private
    var viewHierarchyManager: ViewHierarchyManager!
    
    /// The primary UIKit window.
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            fatalError("Expected `UIWindowScene` type.")
        }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let viewHierarchyManager = Self.primarySWindow
            .makeViewHierarchyManager()
        self.viewHierarchyManager = viewHierarchyManager
        window.rootViewController = viewHierarchyManager.rootViewController
        window.makeKeyAndVisible()
    }
}

// MARK: - api
extension SWindowSceneDelegate {
    
    /// Whether this scene's view hierarchy contains the view.
    func containsView(_ view: SView) -> Bool {
        viewHierarchyManager.containsView(view)
    }
    
    /// Puts the view into a window based on the current location.
    /// - Parameters:
    ///   - destination: The destination view which will appear on-screen.
    ///   - location: The current location view which provides context for the destination view.
    ///   - route: The route to use for the destination view.
    ///   - location: The location to use for the destination view.
    func go(to destinationView: SView, from locationView: SView, withRoute route: SDestinationRoute, atLocation location: SDestinationLocation, withAnimation animated: Bool) {
        viewHierarchyManager
            .go(to: destinationView,
                withRoute: route,
                atLocation: location,
                withAnimation: animated)
    }
    
    func dismiss(_ view: SView, withAnimation animated: Bool) {
        viewHierarchyManager
            .dismiss(view, withAnimation: animated)
    }
}
