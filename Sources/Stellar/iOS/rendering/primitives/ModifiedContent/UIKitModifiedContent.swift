//
//  UIKitModifiedContent.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

/// A content type which is used to 'render' modified content primitive instances.
///
/// Modified content primitives will be converted into this type during the render process.
struct UIKitModifiedContentPrimitive: SContent, AnyUIKitPrimitive {
    
    let attributes: [UIKitViewAttribute]
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitModifiedContentView(attributes: attributes)
    }
}
// content container conformance
extension UIKitModifiedContentPrimitive: _SContentContainer {
    
    var children: [AnySContent] {
        [content]
    }
}
