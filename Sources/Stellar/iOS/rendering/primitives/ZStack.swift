//
//  ZStack.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SZStack: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitZStackPrimitive(alignment: alignment,
                                   content: AnySContent(content)))
    }
}
struct UIKitZStackPrimitive: SContent, AnyUIKitPrimitive {
    
    let alignment: SAlignment
    let content: AnySContent
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitZStack(primitive: self)
    }
}
extension UIKitZStackPrimitive {
    
    init<C: SContent>(alignment: SAlignment = .center,
                      @SContentBuilder content: () -> C) {
        self.alignment = alignment
        self.content = AnySContent(content())
    }
}
extension UIKitZStackPrimitive: _SContentContainer {
    var children: [AnySContent] { [content] }
}
