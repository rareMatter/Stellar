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
}
