//
//  UIKitStacks.swift
//  
//
//  Created by Jesse Spencer on 11/4/21.
//

import StellarFoundation
import UIKit

/// A subclass of `UIStackView` which provides common behaviors for VStack and HStack.
class UIKitPrimitiveStackView: UIStackView, UIKitContent {
    
    var modifiers: [UIKitContentModifier] = []
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        guard let renderable = primitiveContent.value as? UIKitRenderable else { fatalError() }
        let content = renderable.makeRenderableContent(modifiers: modifiers.uiKitModifiers())
        guard let view = content as? UIView else { fatalError() }
        
        if let sibling = sibling {
            guard let siblingView = sibling as? UIView,
                  let index = arrangedSubviews.firstIndex(of: siblingView) else { fatalError() }
            insertArrangedSubview(view, at: index)
        }
        else {
            addArrangedSubview(view)
        }
        
        return content
    }
    
    func update(with primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        fatalError()
    }
    
    func removeChild(_ child: PlatformContent) {
        guard let view = child as? UIView else { fatalError() }
        view.removeFromSuperview()
    }
}
extension UIKitPrimitiveStackView {
    func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        UIView.applyModifiers(modifiers, toView: self)
    }
}

final
class UIKitHStack: UIKitPrimitiveStackView {
    
    init(primitive: AnyHStack, modifiers: [UIKitContentModifier]) {
        super.init(frame: .zero)
        axis = .horizontal
        updateState(with: primitive)
        applyModifiers(modifiers)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(with primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard let anyHStack = primitiveContent.value as? AnyHStack else { fatalError() }
        updateState(with: anyHStack)
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    private
    func updateState(with primitive: AnyHStack) {
        switch primitive.alignment {
        case .top:
            self.alignment = .top
        case .bottom:
            self.alignment = .bottom
        case .center:
            self.alignment = .center
        }
        self.spacing = CGFloat(primitive.spacing)
    }
}

extension SHStack: UIKitRenderable {
    func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitHStack(primitive: self, modifiers: modifiers)
    }
}

final
class UIKitVStack: UIKitPrimitiveStackView {
    
    init(primitive: AnyVStack, modifiers: [UIKitContentModifier]) {
        super.init(frame: .zero)
        axis = .vertical
        updateState(with: primitive)
        applyModifiers(modifiers)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(with primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard let vStack = primitiveContent.value as? AnyVStack else { fatalError() }
        updateState(with: vStack)
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    private
    func updateState(with primitive: AnyVStack) {
        
        switch primitive.alignment {
        case .center:
            self.alignment = .center
        case .leading:
            self.alignment = .leading
        case .trailing:
            self.alignment = .trailing
        }
        self.spacing = CGFloat(primitive.spacing)
    }
}

extension SVStack: UIKitRenderable {
    func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitVStack(primitive: self, modifiers: modifiers)
    }
}
