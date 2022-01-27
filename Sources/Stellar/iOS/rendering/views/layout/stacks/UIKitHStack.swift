//
//  UIKitHStack.swift
//  
//
//  Created by Jesse Spencer on 11/4/21.
//

import UIKit

// TODO: WIP

/// A subclass of `UIStackView` which provides common behaviors for VStack and HStack.
class UIKitPrimitiveStackView: UIStackView, UIKitTargetView {
    
    func addChild(_ context: UIKitTargetView) {
        if let view = context as? UIView {
            addArrangedSubview(view)
        }
    }
    func addChild(_ context: UIKitTargetView,
                  before siblingContext: UIKitTargetView) {
        if let view = context as? UIView {
            guard let siblingView = siblingContext as? UIView,
                  let index = arrangedSubviews.firstIndex(of: siblingView) else {
                addArrangedSubview(view)
                return
            }
            insertArrangedSubview(view, at: index)
        }
    }
    func removeChild(_ context: UIKitTargetView) {
        if let view = context as? UIView {
            view.removeFromSuperview()
        }
    }
    
    func addAttributes(_ attributes: [UIKitViewAttribute]) {
        UIView.addAttributes(attributes, to: self)
    }
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        UIView.removeAttributes(attributes, from: self)
    }
    func updateAttributes(_ attributes: [UIKitViewAttribute]) {
        UIView.updateAttributes(attributes, on: self)
    }
}

final
class UIKitHStack: UIKitPrimitiveStackView {
    
    convenience
    init() {
        self.init(frame: .zero)
        axis = .horizontal
    }
    
    func update(with primitive: AnyUIKitPrimitive2) {
        if let hStack = primitive as? UIKitHStackPrimitive {
            // TODO:
            fatalError("TODO")
        }
    }
}

final
class UIKitVStack: UIKitPrimitiveStackView {
    
    convenience
    init() {
        self.init(frame: .zero)
        axis = .vertical
    }
    
    func update(with primitive: AnyUIKitPrimitive2) {
        if let vStack = primitive as? UIKitVStackPrimitive {
            // TODO:
            fatalError("TODO")
        }
    }
}
