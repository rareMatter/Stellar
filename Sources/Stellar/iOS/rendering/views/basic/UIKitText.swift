//
//  UIKitText.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

import Foundation

final
class UIKitText: _TextView, UIKitTargetRenderableContent {

    func update(with primitive: AnyUIKitPrimitive) {
        if let textView = primitive as? UIKitTextPrimitive {
            // TODO:
            fatalError("TODO")
        }
    }
}
