//
//  SZStack.swift
//  
//
//  Created by Jesse Spencer on 1/14/22.
//

public
struct SZStack<C>: SPrimitiveContent, AnyZStack
where C : SContent {
    
    public
    let alignment: SAlignment
    public
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
    var children: [any SContent] {
        (content as? GroupedContent)?.children
        ?? [content]
    }
}

public
protocol AnyZStack {
    var alignment: SAlignment { get }
    var spacing: Float? { get }
}
