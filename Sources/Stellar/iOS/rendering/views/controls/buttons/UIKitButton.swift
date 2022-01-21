//
//  UIKitButton.swift
//  
//
//  Created by Jesse Spencer on 1/16/22.
//

import Foundation
import UIKit

final
class UIKitButton: UIView, UIKitTargetView {
    
    convenience
    init() {
        self.init(frame: .zero)
    }
    
    func update(with primitive: AnyUIKitPrimitive2) {
        if let button = primitive as? UIKitButtonPrimitive {
            // TODO: Reinstall gestures.
        }
        // TODO:
        fatalError()
    }
}
