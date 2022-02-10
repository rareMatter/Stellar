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
    
    // MARK: - attribute changes
    func addAttributes(_ attributes: [UIKitViewAttribute]) {
        renderableContent.addAttributes(attributes)
    }
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        renderableContent.removeAttributes(attributes)
    }
    func updateAttributes(_ attributes: [UIKitViewAttribute]) {
        renderableContent.updateAttributes(attributes)
    }
}

// MARK: - TODO
// MARK: - Standard UIView rendering functions for any general cases
extension UIView {

    // State updates
    static
    func update(view updatedView: UIView, with primitive: AnyUIKitPrimitive) {
        // TODO:
        fatalError("TODO")
    }
    
    // Children
    static
    func addChild(toView destinationView: UIView, childView: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent?) {
        // TODO:
        fatalError("TODO")
    }
    static
    func removeChild(fromView targetView: UIView, childView: UIKitTargetRenderableContent) {
        // TODO:
        fatalError("TODO")
    }
    
    // Attributes
    static
    func addAttributes(toView targetView: UIView, attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
    static
    func removeAttributes(fromView targetView: UIView, attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
    static
    func updateAttributes(onView targetView: UIView, attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
}
