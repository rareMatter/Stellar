//
//  UIKitComposedModifiedContent.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

/// Use this type to render modified content primitives whose modifiers provide content.
struct UIKitComposedModifiedContentPrimitive: SContent, AnyUIKitPrimitive {
    
    let content: AnySContent
    let modifierContent: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitModifiedContentView(attributes: [])
    }
}
// content container
extension UIKitComposedModifiedContentPrimitive: _SContentContainer {
    
    var children: [AnySContent] {
        [content, modifierContent]
    }
}
