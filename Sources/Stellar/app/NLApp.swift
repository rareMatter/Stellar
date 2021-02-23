//
//  NLAppConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/16/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation
import UIKit

/// A description of an app. A type conforming to this protocol defines the execution entry point using the `@main` attribute, declared on the single conforming type. Single means that, within your executable, there should be only one type which uses `@main` and conforms to this protocol.
public
protocol NLApp {
    
    init()
    
    static func main() -> Void
    
    /// The root destination of the app.
    var rootDestination: Destination { get }
    
    /// A place to perform additional setup immediately after app launch. Move long-running tasks to a background thread to avoid a delayed app launch.
    func performAdditionalSetupForLaunch()
}

// MARK: - application entry point
extension NLApp {
    public
    static func main() {
        // Create NLApp instance and forward control.
        NLAppDelegate.app = Self.init()
        let _ = UIApplicationMain(CommandLine.argc,
                                  CommandLine.unsafeArgv,
                                  nil,
                                  NSStringFromClass(NLAppDelegate.self))
    }
    
    public
    func performAdditionalSetupForLaunch() { }
}
