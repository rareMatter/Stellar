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
class UIKitTarget: RenderableTarget {
    
    /// The UIKit primitive responsible for producing a renderable view.
    let uiKitPrimitive: AnyUIKitPrimitive
    
    #error("This does not need to be lazy because as soon as a child is added to this target, it will be called and instantiated. Therefore, it may also be rational to convert primitives directly into UIViews to act as UIKit primitive types.")
    /// The live view produced by this target's renderable primitive content.
    lazy
    private(set)
    var renderableContent: UIKitTargetRenderableContent = uiKitPrimitive.makeRenderableContent()
    
    // `RenderableTarget` conformance. This property is updated by the framework before the renderer is asked to update the target instance.
    // TODO: What else does the framework use this property for?
    var content: AnySContent
    
    init(content: AnySContent,
         anyUIKitPrimitive: AnyUIKitPrimitive) {
        self.content = content
        self.uiKitPrimitive = anyUIKitPrimitive
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
