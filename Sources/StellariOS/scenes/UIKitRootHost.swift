//
//  UIKitRootHost.swift
//  
//
//  Created by Jesse Spencer on 12/2/22.
//

import StellarFoundation
import UIKit

final
class UIKitRootHost: UIKitContent {
    
    var scenes: []
    var sceneModifiers: [Modifier] = []
    
    init() {
        rootViewController = UIKitRootViewController(nibName: nil, bundle: nil)
    }
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        // TODO: The children should be primitive scenes. This object will accumulate scenes. Scenes will provide an appropriate view hierarchy.
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        // TODO: Ensure that changes to the scene are propagated to the UIKit scene instance, either via delegation or callbacks or publishing.
    }
    
    func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        fatalError("Attempt to remove the scene.")
    }
}

final
class UIKitRootViewController: UIViewController, UIKitContent {
    
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
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        
        // TODO: The child added to this will be the scene provided by the app body. An object is needed for rendering of scenes.
        // This means properties of the scene would need to be backloaded to the UIKit scene which created this controller.
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
    
    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) {}
    
    func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        fatalError("Attempt to remove root of view hierarchy.")
    }
}
