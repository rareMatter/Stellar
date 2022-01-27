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
}
