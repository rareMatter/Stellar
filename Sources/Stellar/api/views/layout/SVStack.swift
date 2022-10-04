//
//  SVStack.swift
//  
//
//  Created by Jesse Spencer on 11/11/21.
//

import Foundation

public
struct SVStack<Content>: SPrimitiveContent
where Content : SContent {
    
    // FIXME: Temp public.
    public
    let alignment: SHorizontalAlignment
    public
    let spacing: Float
    public
    let content: Content
    
    public
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

// FIXME: Temp public.
public
protocol AnyVStack {
    var alignment: SHorizontalAlignment { get }
    var spacing: Float { get }
}
extension SVStack: AnyVStack {}
