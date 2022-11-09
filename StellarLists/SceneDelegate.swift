//
//  SceneDelegate.swift
//  StellarLists
//
//  Created by Jesse Spencer on 4/27/21.
//

import UIKit
import SwiftUI
import Stellar

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create list view.
        let list = AList()
        
        let rootController = RootController(nibName: nil, bundle: nil)
        let reconciler = TreeReconciler(content: list,
                                        rootPlatformContent: rootController) { handler in
            DispatchQueue.main.schedule { handler() }
        }
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = rootController
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

final
class RootController: UIViewController, UIKitContent {
    
    var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [])
        stack.axis = .vertical
        stack.alignment = .center
//        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.autoresizingMask = []
        return stack
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor),
            stack.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor)
        ])
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        fatalError()
    }
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        guard let renderable = primitiveContent.value as? UIKitRenderable else { fatalError() }
        let content = renderable.makeRenderableContent(modifiers: modifiers.uiKitModifiers())
        addChild(content, sibling: sibling)
        return content
    }
    private func addChild(_ content: UIKitContent, sibling: PlatformContent?) {
        guard let view = content as? UIView else { fatalError() }
        
        // TODO: Intrinsic content sizing.
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.frame.size = view.intrinsicContentSize
        
        if let sibling = sibling as? UIView,
           let index = stack.arrangedSubviews.firstIndex(of: sibling) {
            stack.insertArrangedSubview(view, at: index)
        }
        else {
            stack.addArrangedSubview(view)
        }
    }
    
    func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        fatalError()
    }
}
