//
//  NLAppConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/16/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

/// A description of an app used to inform the framework. A type conforming to this protocol defines the execution entry point using the `@main` attribute, declared on the conforming type. There should be only one type which uses `@main` and conforms to this protocol.
public
protocol SApp {
    associatedtype Window: SWindow
    /// The root window of the app.
    var window: Window { get }
    
    init()
    
    static func main() -> Void
    
    /// A place to perform additional setup immediately after app launch. Move long-running tasks to a background thread to avoid a delayed app launch.
    func performAdditionalSetupForLaunch()
}

// MARK: - application entry point
public
extension SApp {
    /// Application entry point.
    static func main() {
        // Create SApp instance and forward control.
        // Provide SApp instance to SAppDelegate statically to avoid subclassing UIApplication.
        SAppDelegate.app = AnySApp(app: Self.init())
        let _ = UIApplicationMain(CommandLine.argc,
                                  CommandLine.unsafeArgv,
                                  nil,
                                  NSStringFromClass(SAppDelegate.self))
    }
}

// MARK: - config methods
public
extension SApp {
    func performAdditionalSetupForLaunch() { }
}
