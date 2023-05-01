//
//  UIKitText.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

import StellarFoundation
import UIKit

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
    
    func update(with primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard let text = primitiveContent.value as? SText else { fatalError() }
        self.text = text.string
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        fatalError()
    }
    
    func removeChild(_ child: PlatformContent) {
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
    
    func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        makeUIKitText(modifiers: modifiers)
    }
    
    func makeUIKitText(modifiers: [UIKitContentModifier]) -> UIKitText {
        UIKitText(string: string, modifiers: modifiers)
    }
}
