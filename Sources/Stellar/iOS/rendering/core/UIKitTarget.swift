//
//  UIKitRenderableTarget.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

// TODO: WIP

import UIKit

/// A class which stores all properties needed for rendering on `UIKit` supported platforms.
final
class UIKitTarget: PlatformRenderable {
    
    /// The UIKit primitive responsible for producing a renderable view.
    let uiKitPrimitive: AnyUIKitPrimitive
    
    /// The live view produced by this target's renderable primitive content.
    let renderableContent: UIKitTargetRenderableContent
    
    // `PlatformRenderable` conformance. This property is updated by the framework before the renderer is asked to update the target instance.
    // TODO: What else does the framework use this property for?
    var content: AnySContent
    
    init(content: AnySContent,
         anyUIKitPrimitive: AnyUIKitPrimitive) {
        self.content = content
        self.uiKitPrimitive = anyUIKitPrimitive
        self.renderableContent = uiKitPrimitive.makeRenderableContent()
    }
}

extension UIKitTarget {
    
    // MARK: - updates
    func update(withPrimitive primitive: AnyUIKitPrimitive) {
        renderableContent.update(with: primitive)
    }
    
    // MARK: - tree changes
    func addChild(_ target: UIKitTarget,
                  before siblingTarget: UIKitTarget?) {
        renderableContent.addChild(target.renderableContent,
                                   before: siblingTarget?.renderableContent)
    }
    func removeChild(_ target: UIKitTarget) {
        renderableContent.removeChild(target.renderableContent)
    }
}

// MARK: - Standard UIView rendering functions for any general cases
extension UIView {
    
    // Children
    static
    func addChild(toView destinationView: UIView,
                  childView: UIView,
                  before siblingView: UIView?) {
        if let siblingView = siblingView {
            destinationView.insertSubview(childView,
                                          belowSubview: siblingView)
        }
        else {
            destinationView.addSubview(childView)
        }

        childView.translatesAutoresizingMaskIntoConstraints = true
        childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    static
    func removeChild(fromView targetView: UIView,
                     childView: UIView) {
        childView.removeFromSuperview()
    }
}
