//
//  UIKitStacks.swift
//  
//
//  Created by Jesse Spencer on 11/4/21.
//

import UIKit

/// A subclass of `UIStackView` which provides common behaviors for VStack and HStack.
class UIKitPrimitiveStackView: UIStackView, UIKitTargetRenderableContent {
    
    func update(with primitive: AnyUIKitPrimitive) {
        assertionFailure("Must override in subclass.")
    }
    
    func addChild(_ context: UIKitTargetRenderableContent) {
        if let view = context as? UIView {
            addArrangedSubview(view)
        }
    }
    func addChild(_ context: UIKitTargetRenderableContent,
                  before siblingContext: UIKitTargetRenderableContent) {
        if let view = context as? UIView {
            guard let siblingView = siblingContext as? UIView,
                  let index = arrangedSubviews.firstIndex(of: siblingView) else {
                addArrangedSubview(view)
                return
            }
            insertArrangedSubview(view, at: index)
        }
    }
    func removeChild(_ context: UIKitTargetRenderableContent) {
        if let view = context as? UIView {
            view.removeFromSuperview()
        }
    }
}

final
class UIKitHStack: UIKitPrimitiveStackView {
    
    init(primitive: UIKitHStackPrimitive) {
        super.init(frame: .zero)
        axis = .horizontal
        update(with: primitive)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override
    func update(with primitive: AnyUIKitPrimitive) {
        guard let hStack = primitive as? UIKitHStackPrimitive else { return }
        
        switch hStack.alignment {
        case .top:
            self.alignment = .top
        case .bottom:
            self.alignment = .bottom
        case .center:
            self.alignment = .center
        }
        self.spacing = CGFloat(hStack.spacing)
    }
}

final
class UIKitVStack: UIKitPrimitiveStackView {
    
    init(primitive: UIKitVStackPrimitive) {
        super.init(frame: .zero)
        axis = .vertical
        update(with: primitive)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override
    func update(with primitive: AnyUIKitPrimitive) {
        guard let vStack = primitive as? UIKitVStackPrimitive else { return }
        
        switch vStack.alignment {
        case .center:
            self.alignment = .center
        case .leading:
            self.alignment = .leading
        case .trailing:
            self.alignment = .trailing
        }
        self.spacing = spacing
    }
}
