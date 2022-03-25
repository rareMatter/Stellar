//
//  UIKitTargetRenderableContent.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation
import UIKit

/// Requirements for a renderable context within UIKit. The context is a distinct renderable container which responds to necessary messages for updates to its renderable tree of elements or attributes for appearance.
///
/// The protocol is class constrained to allow matching of instances during tree changes and updates.
protocol UIKitTargetRenderableContent: AnyObject {
    
    // State updates
    func update(with primitive: AnyUIKitPrimitive)
    
    // Children
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent?)
    func removeChild(_ view: UIKitTargetRenderableContent)
}
extension UIKitTargetRenderableContent
where Self : UIView {

    // Children
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent?) {
        if let view = view as? UIView {
            UIView.addChild(toView: self,
                            childView: view,
                            before: siblingView as? UIView)
        }
    }
    func removeChild(_ view: UIKitTargetRenderableContent) {
        if let view = view as? UIView {
            UIView.removeChild(fromView: self,
                               childView: view)
        }
    }
}
