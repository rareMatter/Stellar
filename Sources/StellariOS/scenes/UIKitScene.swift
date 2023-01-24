//
//  UIKitScene.swift
//  
//
//  Created by Jesse Spencer on 12/1/22.
//

import StellarFoundation
import UIKit

/// `UIKitApp` designates this class to `UIKit` as the scene delegate for any scene created during the app lifecycle.
final
class UIKitScene: UIResponder, UIWindowSceneDelegate {
    
    /// This is provided statically by the application delegate because `UIKit` manages the lifecycle of each scene object.
    static var app: (any SApp)!
    var reconciler: TreeReconciler!
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let rootHost = UIKitRootHost()
        reconciler = TreeReconciler(app: Self.app, rootPlatformContent: rootHost) { handler in
            DispatchQueue.main.schedule { handler() }
        }
        
        guard let windowScene = scene as? UIWindowScene else {
            fatalError("Expected `UIWindowScene` type.")
        }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = rootHost.rootViewController
        window.makeKeyAndVisible()
    }
}
