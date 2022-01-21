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
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required
    init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitive: AnyUIKitPrimitive2) {
        fatalError()
    }
    
    func addChild(_ context: UIKitTargetView) {
        addArrangedSubview(context)
    }
    func addChild(_ context: UIKitTargetView,
                  before siblingContext: UIKitTargetView) {
        guard let index = arrangedSubviews.firstIndex(of: siblingContext) else {
            addArrangedSubview(context)
            return
        }
        insertArrangedSubview(context, at: index)
    }
    func removeChild(_ context: UIKitTargetView) {
        context.removeFromSuperview()
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
    
    override
    init() {
        super.init()
        axis = .horizontal
    }
    
    override
    func update(with primitive: AnyUIKitPrimitive2) {
        if let hStack = primitive as? UIKitHStackPrimitive {
            
        }
    }
}

final
class UIKitVStack: UIKitPrimitiveStackView {
    
    override
    init() {
        super.init()
        axis = .vertical
    }
    
    override
    func update(with primitive: AnyUIKitPrimitive2) {
        if let vStack = primitive as? UIKitVStackPrimitive {
            
        }
    }
}
