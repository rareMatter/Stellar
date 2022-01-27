//
//  UIKitContextMenu.swift
//  
//
//  Created by Jesse Spencer on 1/17/22.
//

import Foundation
import UIKit

final
class UIKitContextMenu: _SContextMenuButton, UIKitTargetView {
    
    func addChild(_ view: UIKitTargetView) {
        if let label = view as? UIKitContextMenuLabel {
            // TODO:
            fatalError("TODO")
        }
        else if let content = view as? UIKitContextMenuContent {
            // TODO:
            fatalError("TODO")
        }
    }
}

/// This class is used to pass details up to its parent, `UIKitContextMenu`, which will use properties of this class to update its appearance.
final
class UIKitContextMenuLabel: UIView, UIKitTargetView {
    
    var titleText: String?
    var image: UIImage?
    
    func addChild(_ view: UIKitTargetView) {
        // TODO: Check for supported primitive types which can be used for the appearance of a context menu button.
        // TODO:
        fatalError("TODO")
    }
}

/// This class is used to pass details up to its parent, `UIKitContextMenu`, which will use properties of this class to update menu items.
final
class UIKitContextMenuContent: UIView, UIKitTargetView {
    
    var title: String = ""
    var image: UIImage? = nil
    var menuID: UIMenu.Identifier? = nil
//    var options: UIMenu.Options
    var children: [UIMenuElement] = []
    
    func addChild(_ view: UIKitTargetView) {
        if let textView = view as? UIKitText {
            self.title = textView.text
        }
        // TODO: Check for images, children.
        else if let button = view as? UIKitButton {
            // TODO: Add child.
        }
        else if let menu = view as? UIKitContextMenu {
            // TODO: Add child.
        }
    }
}
