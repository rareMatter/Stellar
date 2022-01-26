//
//  UIKitZStack.swift
//  
//
//  Created by Jesse Spencer on 11/4/21.
//

import Foundation
import UIKit

final
class UIKitZStack: UIView, UIKitTargetView {
    
    convenience
    init() {
        self.init(frame: .zero)
    }
    
    func update(with primitive: AnyUIKitPrimitive2) {
        // TODO:
        fatalError("TODO")
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
