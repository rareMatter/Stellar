//
//  UIKitText.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

import Foundation
import UIKit

// FIXME: temp public
public
final
class UIKitText: UILabel, UIKitContent {
    
    var modifiers: [UIKitContentModifier] = []
    
    init(string: String, modifiers: [UIKitContentModifier]) {
        super.init(frame: .zero)
        backgroundColor = .white
        text = string
        applyModifiers(modifiers)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard let text = primitiveContent.value as? SText else { fatalError() }
        self.text = text.string
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    public func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        fatalError()
    }
    
    public func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        fatalError()
    }
}
extension UIKitText {

    /// The string being displayed.
    var string: String {
        text ?? ""
    }
}
extension UIKitText {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        UIView.applyModifiers(modifiers, toView: self)
    }
}

extension SText: UIKitRenderable {
    
    public func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        makeUIKitText(modifiers: modifiers)
    }
    
    public func makeUIKitText(modifiers: [UIKitContentModifier]) -> UIKitText {
        UIKitText(string: string, modifiers: modifiers)
    }
}
