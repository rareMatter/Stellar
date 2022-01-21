//
//  UIKitSwipeActionsView.swift
//  
//
//  Created by Jesse Spencer on 1/20/22.
//

import Foundation
import UIKit

final
class UIKitSwipeActionsView: UIView, UIKitTargetView {
    
    convenience
    init() {
        self.init(frame: .zero)
    }
    
    func update(with primitive: AnyUIKitPrimitive2) {
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
}
