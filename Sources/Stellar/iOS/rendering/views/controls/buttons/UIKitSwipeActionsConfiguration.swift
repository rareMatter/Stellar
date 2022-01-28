//
//  UIKitSwipeActionsConfiguration.swift
//  
//
//  Created by Jesse Spencer on 1/20/22.
//

import Foundation
import UIKit

// TODO: Any view which supports (or whose parent supports) swipe actions should check for this view when being told to add a child.
struct UIKitSwipeActionsConfiguration: UIKitTargetView {
    
    init() {}
    
    func update(with primitive: AnyUIKitPrimitive) {
        // TODO:
        fatalError("TODO")
    }
    
    func addChild(_ view: UIKitTargetView) {
        // TODO: When children are added, check for buttons and extract their properties to create a UISwipeActionsConfiguration which will be used by a parent.
        fatalError("TODO")
    }
    func addChild(_ view: UIKitTargetView,
                  before siblingView: UIKitTargetView) {
        // TODO:
        fatalError("TODO")
    }
    func removeChild(_ view: UIKitTargetView) {
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
