//
//  VStack.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SVStack: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitVStackPrimitive(alignment: alignment,
                                   spacing: spacing,
                                   content: AnySContent(content)))
    }
}
struct UIKitVStackPrimitive: SContent, AnyUIKitPrimitive {
    
    let alignment: SHorizontalAlignment
    let spacing: Float
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitVStack(primitive: self)
    }
}
extension UIKitVStackPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}
