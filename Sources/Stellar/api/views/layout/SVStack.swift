//
//  SVStack.swift
//  
//
//  Created by Jesse Spencer on 11/11/21.
//

import Foundation

// TODO: ...
struct SVStack<Content>: SPrimitiveContent
where Content : SContent {
    
    let alignment: SHorizontalAlignment
    let spacing: Float
    let content: Content
    
    init(alignment: SHorizontalAlignment = .center,
         spacing: Float? = nil,
         @SContentBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing ?? defaultStackSpacing
        self.content = content()
    }
}
extension SVStack: _SContentContainer {
    
    var children: [AnySContent] {
        (content as? GroupedContent)?.children
        ?? [AnySContent(content)]
    }
}
