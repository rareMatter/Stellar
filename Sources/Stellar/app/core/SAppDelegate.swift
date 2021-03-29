//
//  SAppDelegate.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/16/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

/// The `UIApplicationDelegate` conforming object given to UIKit for creation. This object is provided an `AnySApp` instance during program entry which it uses to manage app delegate behaviors.
final
class SAppDelegate: UIResponder, UIApplicationDelegate {
    
    // -- app
    /// The app instance provided by top level code during application initialization.
    static var app: AnySApp!
    
    /// Convenient access to the static `NLApp` instance.
    private var app: AnySApp {
        SAppDelegate.app
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        configureAppearance()
        app.performAdditionalSetupForLaunch()
        
        // provide SWindow to SWidowSceneDelegate from SApp.
        SWindowSceneDelegate.primarySWindow = app.window
        
        return true
    }
    
    // -- scenes
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: "Default Scene Config", sessionRole: .windowApplication)
        config.sceneClass = UIWindowScene.self
        config.delegateClass = SWindowSceneDelegate.self
        return config
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

// MARK: Appearance
private
extension SAppDelegate {
    func configureAppearance() {
        // Set tint color
        UIView.appearance().tintColor = UIColor(named: "Nebulist-Blue")
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().isOpaque = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}

// MARK: - helpers
private
extension SAppDelegate {
    
    func sceneContaining(_ view: SView) -> SWindowSceneDelegate? {
        for scene in UIApplication.shared.connectedScenes {
            guard let sceneDelegate = scene.delegate as? SWindowSceneDelegate else {
                assertionFailure("Unexpected scene delegate type.")
                return nil
            }
            if sceneDelegate.containsView(view) {
                return sceneDelegate
            }
        }
        return nil
    }
}

// MARK: - navigation
extension SAppDelegate {
    
    /// Puts the view into a window based on the current location.
    /// - Parameters:
    ///   - destination: The destination view which will appear on-screen.
    ///   - location: The current location view which provides context for the destination view.
    ///   - route: The route to use for the destination view.
    ///   - location: The location to use for the destination view.
    func go(to destinationView: SView, from locationView: SView, withRoute route: SDestinationRoute, atLocation location: SDestinationLocation, withAnimation animated: Bool) {
        let scene = sceneContaining(locationView)
        scene?.go(to: destinationView,
                  from: locationView,
                  withRoute: route,
                  atLocation: location,
                  withAnimation: animated)
    }
    
    /// Removes the view from the screen and hierarchy.
    /// - Parameter view: The view to remove.
    func dismiss(_ view: SView, withAnimation animated: Bool) {
        let scene = sceneContaining(view)
        scene?.dismiss(view, withAnimation: animated)
    }
    
}

// MARK: - global access
/// Convenient global access to the shared application delegate instance.
var appDelegate: SAppDelegate {
    guard let delegate = UIApplication.shared.delegate as? SAppDelegate else {
        fatalError("Unexpected app delegate type.")
    }
    return delegate
}
