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
    let uiKitPrimitive: AnyUIKitPrimitive2
    
    /// The live view produced by this target's renderable primitive content.
    lazy
    private(set)
    var renderableContent: UIKitTargetView = uiKitPrimitive.makeRenderableContent()
    
    // `RenderableTarget` conformance. This property is updated by the framework before the renderer is asked to update the target instance.
    // TODO: What else does the framework use this property for?
    var content: AnySContent
    
    init(content: AnySContent,
         anyUIKitPrimitive: AnyUIKitPrimitive2) {
        self.content = content
        self.uiKitPrimitive = anyUIKitPrimitive
    }
}

extension UIKitTarget {
    
    // MARK: - updates
    func update(withPrimitive primitive: AnyUIKitPrimitive2) {
        renderableContent.update(with: primitive)
    }
    
    // MARK: - tree changes
    func addChild(_ target: UIKitTarget,
                  before siblingTarget: UIKitTarget?) {
        if let siblingTarget = siblingTarget {
            renderableContent.addChild(target.renderableContent,
                              before: siblingTarget.renderableContent)
        }
        else {
            renderableContent.addChild(target.renderableContent)
        }
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
// MARK: - Standard UIView rendering functions
extension UIView {

    // MARK: - attributes
    static
    func addAttributes(_ attributes: [UIKitViewAttribute],
                       to view: UIView) {
        fatalError()
    }
    static
    func removeAttributes(_ attributes: [UIKitViewAttribute],
                          from view: UIView) {
        fatalError()
    }
    static
    func updateAttributes(_ attributes: [UIKitViewAttribute],
                          on view: UIView) {
        fatalError()
    }
    
    static
    func addChild(_ context: UIKitTargetView) {
        fatalError()
    }
    static
    func addChild(_ context: UIKitTargetView,
                  before siblingContext: UIKitTargetView) {
        fatalError()
    }
    static
    func removeChild(_ context: UIKitTargetView) {
        fatalError()
    }
}
