//
//  NLAppDelegate.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/16/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

final class NLAppDelegate: UIResponder, UIApplicationDelegate {
    
    // -- app
    /// The app instance provided by top level code during application initialization.
    static var app: NLApp!
    
    /// Convenient access to the static `NLApp` instance.
    private var app: NLApp {
        NLAppDelegate.app
    }
    
    var window: UIWindow?
    
    // -- view controller hierarchy
    private let rootController = RootController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        configureAppearance()
        
        app.performAdditionalSetupForLaunch()
        
        // Initiate view controller chain in the main window and start app
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = rootController.rootViewController
        window.makeKeyAndVisible()
        
        return true
    }
}

// MARK: Appearance
private
extension NLAppDelegate {
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
