//
//  SContextMenuButton.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SContextMenuButton<Label, Content>: SPrimitiveContent
where Label : SContent, Content : SContent {
    let content: Content
    let label: Label
}

public
extension SContextMenuButton {
    
    /// Creates a menu with a custom label.
    /// - Parameters:
    ///   - content: A group of menu items.
    ///   - label: A view describing the content of the menu.
    init(content: () -> Content,
         label: () -> Label) {
        self.content = content()
        self.label = label()
    }
    
    init<S>(_ title: S,
            content: () -> Content)
    where Label == SText, S : StringProtocol {
        self.content = content()
        self.label = .init(title)
    }
}

/// A wrapper used to specify the content of a context menu button primitive.
struct _SContextMenuButtonContent<Content>: SPrimitiveContent
where Content : SContent {
    let content: Content
}
struct _SContextMenuButtonLabel<Content>: SPrimitiveContent
where Content : SContent {
    let content: Content
}
