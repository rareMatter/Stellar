//
//  UIKitTextEditor.swift
//  
//
//  Created by Jesse Spencer on 1/18/22.
//

import Foundation
import UIKit

final
class UIKitTextEditor: _TextView, UIKitContent {
    
    var modifiers: [UIKitContentModifier] = []

    init(primitive: STextEditor, modifiers: [UIKitContentModifier]) {
        super.init(frame: .zero,
                   textContainer: nil)
        updateState(with: primitive)
        applyModifiers(modifiers)
    }

    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard let primitive = primitiveContent.value as? STextEditor else { fatalError() }
        updateState(with: primitive)
        applyModifiers(modifiers.uiKitModifiers())
    }
    
    private
    func updateState(with primitive: STextEditor) {
        self.text = primitive.text
        self.placeholder = primitive.placeholderText
        self.didChange = { textView in
            primitive.onTextChange(textView.text)
        }
        self.inputAccessoryView = primitive.inputAccessoryView
    }
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        fatalError()
    }
    
    func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        fatalError()
    }
}
extension UIKitTextEditor {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        UIView.applyModifiers(modifiers, toView: self)
    }
}

extension STextEditor: UIKitRenderable {
    public func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitTextEditor(primitive: self, modifiers: modifiers)
    }
}
