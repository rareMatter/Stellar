//
//  ContextMenu.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SContextMenuButton: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitContextMenuPrimitive(label: .init(label),
                                        content: .init(content)))
    }
}
struct UIKitContextMenuPrimitive: SContent, AnyUIKitPrimitive {
    
    let label: AnySContent
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitContextMenu()
    }
}
extension UIKitContextMenuPrimitive: _SContentContainer {
    var children: [AnySContent] { [label, content] }
}

extension _SContextMenuButtonContent: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitContextMenuButtonContentPrimitive(content: AnySContent(content)))
    }
}
struct UIKitContextMenuButtonContentPrimitive: SContent, AnyUIKitPrimitive {
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitContextMenuContent()
    }
}
extension UIKitContextMenuButtonContentPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}
