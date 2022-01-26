//
//  UIKitLabel.swift
//  
//
//  Created by Jesse Spencer on 11/4/21.
//

import UIKit

// TODO: ...

/// A view which displays one or more lines of read-only text.
class UIKitLabelPrimitive: UILabel, UIKitTargetView {
    
    func update(with primitive: AnyUIKitPrimitive2) {
        if let label = primitive as? UIKitLabelPrimitive {
            // TODO:
            fatalError("TODO")
        }
    }
    
    func addChild(_ view: UIKitTargetView) {
        // TODO:
        fatalError("TODO")
    }
    func addChild(_ view: UIKitTargetView, before siblingView: UIKitTargetView) {
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
