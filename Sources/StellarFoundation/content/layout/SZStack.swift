//
//  SZStack.swift
//  
//
//  Created by Jesse Spencer on 1/14/22.
//

import Foundation

public
struct SZStack<C: SContent>: SPrimitiveContent {
    
    let alignment: SAlignment
    let spacing: Float?
    let content: C
    
    public
    init(alignment: SAlignment = .center,
         spacing: Float? = nil,
         @SContentBuilder content: () -> C) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
}
extension SZStack: _SContentContainer {
    var children: [AnySContent] {
        (content as? GroupedContent)?.children ?? [.init(content)]
    }
}

// FIXME: temp public
public
protocol AnyZStack {
    var alignment: SAlignment { get }
    var spacing: Float? { get }
}
