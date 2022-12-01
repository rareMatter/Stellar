//
//  UIKitContextMenu.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

import StellarFoundation
import UIKit
import UIKitParts

final
class UIKitContextMenu: UIControl, UIKitContent {
    
    private(set)
    var title: String = .init()
    
    /// Computed from `menuContent` or nil if content has not been provided.
    var menu: UIMenu? {
        if let menuContent = menuContent {
            return .init(title: title,
                         subtitle: nil,
                         image: nil,
                         identifier: nil,
                         options: .init(),
                         children: menuContent.menuChildren)
        }
        else {
            return nil
        }
    }
    
    /// The menu content which will be provided as a child and stored so a menu can be generated from it when needed.
    private
    var menuContent: UIKitContextMenuContent? = nil
    
    var modifiers: [UIKitContentModifier] = []
    
    init(modifiers: [UIKitContentModifier]) {
        super.init(frame: .zero)
        isContextMenuInteractionEnabled = true
        showsMenuAsPrimaryAction = true
        applyModifiers(modifiers)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) { fatalError() }

    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        
        switch primitiveContent.type {
        case .text(let text):
            title = text.string
        
        case .menuContent(let anyMenuContent):
            menuContent = anyMenuContent.makeUIKitContextMenuContent(modifiers: modifiers.uiKitModifiers())
            return menuContent
        
        default:
            guard let renderable = primitiveContent.value as? UIKitRenderable,
                  let view = renderable.makeRenderableContent(modifiers: modifiers.uiKitModifiers()) as? UIView else { fatalError() }
            UIView.addChild(toView: self, childView: view, before: sibling as? UIView)
        }
        
        return nil
    }
    
    func removeChild(_ child: PlatformContent, for task: UnmountHostTask) {
        fatalError()
    }

    override
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        if menu != nil {
            return .init(identifier: nil,
                         previewProvider: nil) { [menu] suggestedActions in
                menu
            }
        }
        else { return nil }
    }
}
extension UIKitContextMenu {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        // TODO:
        fatalError()
    }
}

/// Stores properties which form a `UIMenu`.
///
/// When children are added which match a supported property type for a menu they are converted into stored properties.
final
class UIKitContextMenuContent: UIKitContent {
    
    var menuChildren: [UIMenuElement] {
        children.compactMap { content in
            if let button = content as? UIKitButton {
                // TODO: When UIKitImage is added, check button here for image.
                return UIAction(title: button.text?.string ?? "",
                                         subtitle: nil,
                                         image: nil,
                                         identifier: nil,
                                         discoverabilityTitle: nil,
                                         attributes: .init(),
                                         state: .on,
                                         handler: { _ in
                    button.tapGesture.handler()
                })
            }
            else if let menu = content as? UIKitContextMenu,
                    let uiKitMenu = menu.menu {
                return uiKitMenu
            }
            else { return nil }
        }
    }
    
    /// Child content which will be converted into properties of a `UIMenu` on demand.
    private
    var children: [UIKitContent] = []
    
    var modifiers: [UIKitContentModifier] = []
    
    init(modifiers: [UIKitContentModifier]) {
        applyModifiers(modifiers)
    }
    
    func update(withPrimitive primitiveContent: PrimitiveContext, modifiers: [Modifier]) { fatalError() }
    
    func addChild(for primitiveContent: PrimitiveContext, preceedingSibling sibling: PlatformContent?, modifiers: [Modifier], context: HostMountingContext) -> PlatformContent? {
        
        switch primitiveContent.type {
        case .button, .menuContent:
            guard let uiKitContent = primitiveContent.value as? UIKitContent else { fatalError() }
            
            if let sibling = sibling,
               let siblingContent = sibling as? UIKitContent,
               let index = children.firstIndex(where: { $0 === siblingContent }) {
                children.insert(uiKitContent, at: index)
            }
            else {
                children.append(uiKitContent)
            }
            
            return uiKitContent
            
        default:
            fatalError()
        }
    }
    
    func removeChild(_ child: PlatformContent,
                for task: UnmountHostTask) {
        if let content = child as? UIKitContent,
           let index = children.firstIndex(where: { $0 === content }) {
            children.remove(at: index)
        }
    }
}
extension UIKitContextMenuContent {
    private func applyModifiers(_ modifiers: [UIKitContentModifier]) {
        // TODO:
        fatalError()
    }
}

extension AnyContextMenuButton {
    func makeUIKitContextMenu(modifiers: [UIKitContentModifier]) -> UIKitContextMenu {
        .init(modifiers: modifiers)
    }
}
extension SContextMenuButton: UIKitRenderable {
    func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitContextMenu(modifiers: modifiers)
    }
}

extension AnyContextMenuButtonContent {
    func makeUIKitContextMenuContent(modifiers: [UIKitContentModifier]) -> UIKitContextMenuContent {
        .init(modifiers: modifiers)
    }
}
extension _SContextMenuButtonContent: UIKitRenderable {
    func makeRenderableContent(modifiers: [UIKitContentModifier]) -> UIKitContent {
        UIKitContextMenuContent(modifiers: modifiers)
    }
}
