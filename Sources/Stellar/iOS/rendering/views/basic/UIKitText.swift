//
//  UIKitText.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

import Foundation

final
class UIKitText: _TextView, UIKitTargetView {

    func update(with primitive: AnyUIKitPrimitive2) {
        if let textView = primitive as? UIKitTextPrimitive {
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
