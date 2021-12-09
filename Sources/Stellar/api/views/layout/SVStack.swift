//
//  SVStack.swift
//  
//
//  Created by Jesse Spencer on 11/11/21.
//

import Foundation
import CoreGraphics

// TODO: ...
struct SVStack<Content>: SPrimitiveContent
where Content : SContent {
    
    let alignment: SHorizontalAlignment
    let spacing: CFloat
    let content: Content
    
    init(alignment: SHorizontalAlignment = .center,
         spacing: CGFloat? = nil,
         @SContentBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = CFloat(spacing ?? defaultStackSpacing)
        self.content = content()
    }
}
extension SVStack: _SContentContainer {
    
    var children: [AnySContent] {
        (content as? GroupedContent)?.children
        ?? [AnySContent(content)]
    }
}
