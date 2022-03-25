//
//  HStack.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SHStack: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitHStackPrimitive(alignment: alignment,
                                   spacing: spacing,
                                   content: AnySContent(content)))
    }
}
struct UIKitHStackPrimitive: SContent, AnyUIKitPrimitive {
    let alignment: SVerticalAlignment
    let spacing: Float
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitHStack(primitive: self)
    }
}
extension UIKitHStackPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}
