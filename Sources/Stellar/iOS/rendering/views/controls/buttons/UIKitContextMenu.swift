//
//  UIKitContextMenu.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

import Foundation
import UIKit

final
class UIKitContextMenu: UIControl, UIKitTargetRenderableContent {
    
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
    
    init() {
        super.init(frame: .zero)
        isContextMenuInteractionEnabled = true
        showsMenuAsPrimaryAction = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addChild(_ view: UIKitTargetRenderableContent) {
        // Use text to create a title.
        if let text = view as? UIKitText {
            title = text.text
        }
        // Use `UIKitContextMenuContent` to later create the menu on demand.
        else if let content = view as? UIKitContextMenuContent {
            menuContent = content
        }
        // Hand off any other views to be added as a standard child. (Any views here should be coming from other types in the label content.
        else {
            UIView.addChild(view)
        }
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

/// Stores properties which form a `UIMenu`.
///
/// When children are added which match a supported property type for a menu they are converted into stored properties.
final
class UIKitContextMenuContent: UIKitTargetRenderableContent {
    
    var menuChildren: [UIMenuElement] {
        children.compactMap { content in
            if let button = content as? UIKitButton {
                // TODO: When UIKitImage is added, check button here for image.
                return UIAction(title: button.title,
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
    var children: [UIKitTargetRenderableContent] = []
    
    /// View attributes which have been applied to this content.
    private(set)
    var attributes: [UIKitViewAttribute] = []
    
    func update(with primitive: AnyUIKitPrimitive) {}
    
    func addChild(_ view: UIKitTargetRenderableContent) {
        if view is UIKitButton || view is UIKitContextMenu {
            children.append(view)
        }
    }
    
    func addChild(_ view: UIKitTargetRenderableContent,
                  before siblingView: UIKitTargetRenderableContent) {
        if view is UIKitButton || view is UIKitContextMenu {
            if let siblingIndex = children.firstIndex(where: { $0 === siblingView }) {
                children.insert(view, at: siblingIndex)
            }
            else {
                children.append(view)
            }
        }
    }
    
    func removeChild(_ view: UIKitTargetRenderableContent) {
        if let index = children.firstIndex(where: { $0 === view }) {
            children.remove(at: index)
        }
    }
    
    func addAttributes(_ attributes: [UIKitViewAttribute]) {
        self.attributes.append(contentsOf: attributes)
    }
    func removeAttributes(_ attributes: [UIKitViewAttribute]) {
        let diff = self.attributes.difference(from: attributes)
        self.attributes = self.attributes.applying(diff) ?? self.attributes
    }
    func updateAttributes(_ attributes: [UIKitViewAttribute]) {
        debugPrint("\(self): Attempt to update attributes in a configuration whose parent will not be notified.")
    }
}
