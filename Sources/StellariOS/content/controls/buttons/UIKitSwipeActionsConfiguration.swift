//
//  UIKitSwipeActionsConfiguration.swift
//  
//
//  Created by Jesse Spencer on 1/20/22.
//

import StellarFoundation
import UIKit

final
class UIKitSwipeActionsConfiguration: UIKitContent {
    
    /// Computed from current state.
    var uiConfiguration: UISwipeActionsConfiguration {
        let actions = buttons.map { button in
            UIContextualAction(style: .normal,
                               title: button.text?.string,
                               handler: { action, originView, completion in
                button.tapHandlerContainer?.t()
                completion(true)
            })
        }
        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = allowsFullSwipe
        return config
    }
    /// The edge to install the swipe actions.
    private(set) var edge: SHorizontalEdge
    
    /// Apply this property to the swipe actions configuration before providing it to clients.
    private var allowsFullSwipe: Bool
    /// Buttons added as children. Use these to create the swipe actions.
    private var buttons: [UIKitButton] = []
    
    var modifiers: [UIKitContentModifier] = []
    
    init(edge: SHorizontalEdge, allowsFullSwipe: Bool, modifiers: [UIKitContentModifier]) {
        self.edge = edge
        self.allowsFullSwipe = allowsFullSwipe
        applyModifiers(modifiers)
    }
    
    func update(with primitiveContent: PrimitiveContext, modifiers: [Modifier]) {
        guard let config = primitiveContent.value as? UIKitSwipeActionsConfiguration else { fatalError() }
        edge = config.edge
        allowsFullSwipe = config.allowsFullSwipe
        applyModifiers(modifiers.uiKitModifiers())
    }

    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        guard let renderable = primitiveContent.value as? UIKitRenderable else { fatalError() }
        let content = renderable.makeRenderableContent(modifiers: modifiers.uiKitModifiers())
        
        if let button = content as? UIKitButton {
            if let sibling = sibling,
               let renderable = sibling as? UIKitRenderable,
               let siblingButton = renderable.makeRenderableContent(modifiers: modifiers.uiKitModifiers()) as? UIKitButton,
               let index = buttons.firstIndex(of: siblingButton) {
                buttons.insert(button, at: index)
            }
            else {
                buttons.append(button)
            }
            
            return content
        }
        else { fatalError() }
    }
    
    func removeChild(_ child: PlatformContent) {
        if let button = child as? UIKitButton,
           let index = buttons.firstIndex(of: button) {
            buttons.remove(at: index)
        }
    }
}
extension UIKitSwipeActionsConfiguration {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        // TODO:
        fatalError()
    }
}
