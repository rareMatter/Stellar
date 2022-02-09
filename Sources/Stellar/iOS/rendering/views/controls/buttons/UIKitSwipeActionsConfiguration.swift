//
//  UIKitSwipeActionsConfiguration.swift
//  
//
//  Created by Jesse Spencer on 1/20/22.
//

import Foundation
import UIKit

// TODO: Any view which supports (or whose parent supports) swipe actions should check for this view when being told to add a child.
final
class UIKitSwipeActionsConfiguration: UIKitTargetRenderableContent {
    
    init() {}
    
    func update(with primitive: AnyUIKitPrimitive) {
        // TODO:
        fatalError("TODO")
    }
    
    func addChild(_ view: UIKitTargetRenderableContent) {
        // TODO: When children are added, check for buttons and extract their properties to create a UISwipeActionsConfiguration which will be used by a parent.
        fatalError("TODO")
    }
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent) {
        // TODO:
        fatalError("TODO")
    }
    func removeChild(_ view: UIKitTargetRenderableContent) {
        // TODO:
        fatalError("TODO")
    }
    
    func addAttributes(_ attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
    
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
    
    func updateAttributes(_ attributes: [UIKitViewAttribute]) {
        // TODO:
        fatalError("TODO")
    }
}
