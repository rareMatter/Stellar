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
    let view: UIViewPrimitiveProtocol
    
    // `RenderableTarget` conformance. This property is updated by the framework before the renderer is asked to update the target instance.
    // TODO: What else does the framework use this property for?
    var content: AnySContent
    
    init<C: SContent>(_ content: C,
                      uiKitPrimitive: AnyUIKitPrimitive) {
        self.view = makeView(from: uiKitPrimitive)
        self.content = AnySContent(content)
        view.addAttributes(uiKitPrimitive.attributes)
    }
}

// TODO: Move this.
func makeView(from primitive: AnyUIKitPrimitive) -> UIViewPrimitiveProtocol {
    // TODO: ...
    switch primitive.viewType {
        case .root(_):
            break
        case .image:
            break
        case .text:
            break
        
        default:
            assertionFailure()
    }
    
    fatalError("stub")
}
