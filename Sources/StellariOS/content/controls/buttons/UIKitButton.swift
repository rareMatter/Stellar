//
//  UIKitButton.swift
//  
//
//  Created by Jesse Spencer on 1/16/22.
//

import Foundation
import UIKit
import StellarFoundation
import UIKitParts
import utilities

final
class UIKitButton: UIControl, UIKitContent {
    
    // -- taps
    private(set)
    var tapHandlerContainer: SIdentifiableContainer<() -> Void>? = nil
    
    private(set)
    var tapGesture: TapGestureRecognizer
    
    // -- children
    private(set)
    var text: UIKitText? = nil {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    var modifiers: [UIKitContentModifier] = []
    
    public override var intrinsicContentSize: CGSize {
        // TODO:
        text?.intrinsicContentSize ?? .zero
    }
    
    init(tapHandlerContainer: SIdentifiableContainer<() -> Void>, modifiers: [UIKitContentModifier]) {
        self.tapHandlerContainer = tapHandlerContainer
        self.tapGesture = .init(tapHandlerContainer.t)
        
        super.init(frame: .zero)

        applyModifiers(modifiers)
        installTapGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard case let .button(anyButton) = primitiveContent.type else { fatalError() }
        if anyButton.actionHandler != tapHandlerContainer {
            tapGesture.handler = anyButton.actionHandler.t
        }
        applyModifiers(modifiers.uiKitModifiers())
        // TODO: If children change, the size of this may need to update to accomodate. A generalized layout handling chain may need to be implemented. Or - review Dynamic Content handling implemented by Content Cell.
    }
    
    func addChild(for primitiveContent: PrimitiveContext,
                  preceedingSibling sibling: PlatformContent?,
                  modifiers: [Modifier],
                  context: HostMountingContext) -> PlatformContent? {
        
        // TODO: Need support for UIKitImage.
        switch primitiveContent.type {
        case .text(let text):
            let text = text.makeUIKitText(modifiers: modifiers.uiKitModifiers())
            addChildText(text, sibling: sibling as? UIKitContent)
            return text
            
        default:
            return nil
        }
    }
    
    private func addChildText(_ text: UIKitText, sibling: UIKitContent?) {
        self.text = text
        UIView.addChild(toView: self,
                        childView: text,
                        before: sibling as? UIView)
    }
    
    
    func removeChild(_ child: PlatformContent) {
        if child is UIKitText {
            guard let text = text else {
                assertionFailure("Unexpected child removal in \(Self.self). Child: \(child). Child will not be removed.")
                return
            }

            UIView.removeChild(fromView: self, childView: text)
            self.text = nil
        }
    }
}
extension UIKitButton {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        UIView.applyModifiers(modifiers, toView: self)
    }
}

private
extension UIKitButton {
    
    func installTapGesture() {
        addGestureRecognizer(tapGesture.tapGestureRecognizer)
    }
}

extension SButton: UIKitRenderable {
    func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        makeUIKitButton(modifiers: modifiers)
    }
    
    func makeUIKitButton(modifiers: [UIKitContentModifier]) -> UIKitButton {
        UIKitButton(tapHandlerContainer: actionHandler, modifiers: modifiers)
    }
}
