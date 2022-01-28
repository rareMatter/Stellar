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
    
    func update(with primitive: AnyUIKitPrimitive) {
        if let button = primitive as? UIKitButtonPrimitive {
            // TODO: Reinstall gestures.
        }
        // TODO:
        fatalError()
    }
}
