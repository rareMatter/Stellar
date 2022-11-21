//
//  UIKitViewAttributesConfiguration.swift
//  
//
//  Created by Jesse Spencer on 2/14/22.
//

import Foundation
import UIKit

/*
// FIXME: Temp public.
public
final
class UIKitModifiedContent: UIKitContent {
    
    private var modifiers: [UIKitContentModifier]
    
    /// The content which has this modifier applied.
    private var childContent: UIKitContent?
    
    /// A handler to be called after content has been modified.
    private let contentHandler: (UIKitContent) -> Void
    
    init(modifier: UIKitContentModifier, addModifiedContent: @escaping (UIKitContent) -> Void) {
        self.modifiers = [modifier]
        self.contentHandler = addModifiedContent
    }
    
    public func addChild(for primitiveContent: PrimitiveContentContext, preceedingSibling sibling: PlatformContent?, context: HostMountingContext) -> PlatformContent? {
        
        switch primitiveContent.type {
        case .modifiedContent(let anyModifiedContent):
            // extract modifier and return
            guard let uiKitRenderableModifier = anyModifiedContent as? UIKitRenderableModifier else { fatalError() }
            modifiers.append(uiKitRenderableModifier.makeModifier())
            return nil
            
        default:
            guard let uiKitContent = primitiveContent.value as? UIKitContent else { fatalError() }
            uiKitContent.applyModifiers(modifiers)
            childContent = uiKitContent
            contentHandler(uiKitContent)
            
            return uiKitContent
        }
    }
    
    public func update(withPrimitive primitiveContent: PrimitiveContentContext) {
        fatalError()
    }

    public func removeChild(_ child: PlatformContent,
                for task: UnmountHostTask) {
        fatalError()
    }
    
    public func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        fatalError()
    }
}
// helpers
private
extension UIKitModifiedContent {
    /*
    /// Applies the attributes.
    ///
    /// This will update existing attributes or apply new attributes.
    func applyAttributes(_ attributes: [UIKitViewAttribute]) {
        attributes.forEach { attribute in
            switch attribute {
            case let .cornerRadius(radius,
                                   antialiased):
                layer.masksToBounds = true
                layer.cornerRadius = radius
                layer.allowsEdgeAntialiasing = antialiased
            case let .disabled(isDisabled):
                isUserInteractionEnabled = !isDisabled
            case let .tapHandler(hashableClosure):
                let tapGesture = TapGestureRecognizer(hashableClosure.handler)
                addGestureRecognizer(tapGesture.tapGestureRecognizer)
                self.tapGesture = tapGesture
            case let .identifier(id):
                self.id = id
            }
        }
    }
    /// Removes the attributes.
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        attributes.forEach { attribute in
            switch attribute {
            case .cornerRadius:
                layer.cornerRadius = 0
                layer.allowsEdgeAntialiasing = false
            case .disabled:
                isUserInteractionEnabled = true
            case .tapHandler:
                if let tapGesture = self.tapGesture {
                    removeGestureRecognizer(tapGesture.tapGestureRecognizer)
                }
                self.tapGesture = nil
            case .identifier:
                self.id = nil
            }
        }
    }
     */
}
 */

/*
extension AnyModifiedContent {
    
    public func makeUIKitModifiedContent(addModifiedContent: @escaping (UIKitContent) -> Void) -> UIKitModifiedContent {
        UIKitModifiedContent(modifier: (anySModifier as! UIKitRenderableModifier).makeModifier(), addModifiedContent: addModifiedContent)
    }
}
 */
