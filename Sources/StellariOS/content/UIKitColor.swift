//
//  UIKitColor.swift
//  
//
//  Created by Jesse Spencer on 1/18/22.
//

import StellarFoundation
import UIKit
import UIKitParts

final
class UIKitColor: UIView, UIKitContent {
    
    init(color: AnyColor, modifiers: [UIKitContentModifier]) {
        super.init(frame: .zero)
        updateState(withColor: color)
        applyModifiers(modifiers)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard case let .color(color) = primitiveContent.type else { fatalError() }
        updateState(withColor: color)
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        fatalError()
    }
    
    private
    func updateState(withColor color: AnyColor) {
        backgroundColor = .makeColor(color)
    }
    
    func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        fatalError()
    }
}
extension UIKitColor {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        UIView.applyModifiers(modifiers, toView: self)
    }
}

extension PrimitiveColor: UIKitRenderable {
    func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitColor(color: self, modifiers: modifiers)
    }
}
