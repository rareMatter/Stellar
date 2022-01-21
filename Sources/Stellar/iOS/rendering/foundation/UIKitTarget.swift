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
    
    /// The live view produced by this target's renderable primitive content.
    let rootView: UIKitTargetView
    
    // `RenderableTarget` conformance. This property is updated by the framework before the renderer is asked to update the target instance.
    // TODO: What else does the framework use this property for?
    var content: AnySContent
    
    init(content: AnySContent,
         rootView: UIKitTargetView) {
        self.content = content
        self.rootView = rootView
    }
}

extension UIKitTarget {
    
    // MARK: - updates
    func update(withPrimitive primitive: AnyUIKitPrimitive2) {
        rootView.update(with: primitive)
    }
    
    // MARK: - tree changes
    func addChild(_ target: UIKitTarget,
                  before siblingTarget: UIKitTarget?) {
        if let siblingTarget = siblingTarget {
            rootView.addChild(target.rootView,
                              before: siblingTarget.rootView)
        }
        else {
            rootView.addChild(target.rootView)
        }
    }
    func removeChild(_ target: UIKitTarget) {
        rootView.removeChild(target.rootView)
    }
    
    // MARK: - attribute changes
    func addAttributes(_ attributes: [UIKitViewAttribute]) {
        rootView.addAttributes(attributes)
    }
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        rootView.removeAttributes(attributes)
    }
    func updateAttributes(_ attributes: [UIKitViewAttribute]) {
        rootView.updateAttributes(attributes)
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
