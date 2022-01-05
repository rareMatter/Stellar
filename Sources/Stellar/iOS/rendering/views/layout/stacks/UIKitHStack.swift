//
//  UIKitHStack.swift
//  
//
//  Created by Jesse Spencer on 11/4/21.
//

import UIKit

// TODO: WIP

/// A subclass of `UIStackView` which provides common behaviors for VStack and HStack.
class UIKitPrimitiveStackView: UIStackView, UIKitRenderableContext {
    
    var primitive: AnyUIKitPrimitive
    var attributes: [UIKitViewAttribute] = []
    
    required
    init(primitive: AnyUIKitPrimitive) {
        self.primitive = primitive
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required
    init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(using primitive: AnyUIKitPrimitive) {
        self.primitive = primitive
    }
}

final
class UIKitHStack: UIKitPrimitiveStackView {
    
    override
    var primitive: AnyUIKitPrimitive {
        didSet {
            guard primitive.viewType == .hStack else {
                assertionFailure("Incompatible primitive type provided: \(primitive.viewType)")
                return
            }
            updateAttributes(primitive.attributes)
        }
    }
    
    required
    init(primitive: AnyUIKitPrimitive) {
        super.init(primitive: primitive)
        axis = .horizontal
    }
    
    @available(*, unavailable)
    required
    init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final
class UIKitVStack: UIKitPrimitiveStackView {
    
    override
    var primitive: AnyUIKitPrimitive {
        didSet {
            guard primitive.viewType == .vStack else {
                assertionFailure("Incompatible primitive type provided: \(primitive.viewType)")
                return
            }
            updateAttributes(primitive.attributes)
        }
    }
    
    required
    init(primitive: AnyUIKitPrimitive) {
        super.init(primitive: primitive)
        axis = .vertical
    }
    
    @available(*, unavailable)
    required
    init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
