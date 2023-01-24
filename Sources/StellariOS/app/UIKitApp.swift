//
//  UIKitApp.swift
//  
//
//  Created by Jesse Spencer on 12/1/22.
//

import StellarFoundation
import UIKit

extension SApp {
    
    /// Application entry point.
    static func main() {
        UIKitApp.app = self.init()
        let _ = UIApplicationMain(CommandLine.argc,
                                  CommandLine.unsafeArgv,
                                  nil,
                                  NSStringFromClass(UIKitApp.self))
    }
}

/// This class handles app lifecycle interactions provided by `UIKit`.
final
class UIKitApp: UIResponder, UIApplicationDelegate, UIWindowSceneDelegate {
    
    /// This is provided statically in `main` at launch because `UIKit` manages the lifecycle of this application delegate.
    static var app: (any SApp)!
    
    var reconciler: TreeReconciler!
    var rootHost: UIKitRootHost!
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        rootHost = UIKitRootHost()
        reconciler = TreeReconciler(app: Self.app, rootPlatformContent: rootHost) { handler in
            DispatchQueue.main.schedule { handler() }
        }
        
        return true
    }
    
    // -- scenes
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // TODO: Retrieve appropriate scene description. If missing, throw error.
        let config = UISceneConfiguration(name: "Default Scene Config", sessionRole: .windowApplication)
        config.sceneClass = UIWindowScene.self
        config.delegateClass = UIKitScene.self
        UIKitScene.app = Self.app
        return config
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // On the app-scene level, the system needs control of object creation. On the content level, the app/user can have control of object creation. This means revision is needed in the reconciler when created from an App instance. Somewhat of an inversion of control is needed.
        // TODO: Retrieve appropriate scene description. If missing, throw error.
        
        guard let windowScene = scene as? UIWindowScene else {
            fatalError("Expected `UIWindowScene` type.")
        }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = rootHost.rootViewController
        window.makeKeyAndVisible()
    }
}
