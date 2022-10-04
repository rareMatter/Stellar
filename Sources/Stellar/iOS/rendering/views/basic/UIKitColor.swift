//
//  UIKitColor.swift
//  
//
//  Created by Jesse Spencer on 1/18/22.
//

import Foundation
import UIKit

final
class UIKitColor: UIView, UIKitContent {
    
    init(color: SColor, modifiers: [UIKitContentModifier]) {
        super.init(frame: .zero)
        updateState(withColor: color)
        applyModifiers(modifiers)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContentContext, modifiers: [AnySContentModifier]) {
        guard case let .color(color) = primitiveContent.type else { fatalError() }
        updateState(withColor: color)
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    func addChild(for primitiveContent: PrimitiveContentContext, preceedingSibling sibling: PlatformContent?, modifiers: [AnySContentModifier], context: HostMountingContext) -> PlatformContent? {
        fatalError()
    }
    
    private
    func updateState(withColor color: SColor) {
        backgroundColor = .makeColor(r: color.red,
                                     g: color.green,
                                     b: color.blue,
                                     opacity: color.opacity,
                                     colorSpace: color.colorSpace)
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

extension SColor: UIKitRenderable {
    public func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitColor(color: self, modifiers: modifiers)
    }
}
