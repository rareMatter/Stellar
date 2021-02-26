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
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        configureAppearance()
        app.performAdditionalSetupForLaunch()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = app.rootController.rootViewController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
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
