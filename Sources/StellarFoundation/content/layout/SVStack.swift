//
//  SVStack.swift
//  
//
//  Created by Jesse Spencer on 11/11/21.
//

public
struct SVStack<C>: SPrimitiveContent, AnyVStack
where C : SContent {
    
    public
    let alignment: SHorizontalAlignment
    public
    let spacing: Float
    
    let content: C
    
    public
    init(alignment: SHorizontalAlignment = .center,
         spacing: Float? = nil,
         @SContentBuilder content: () -> C) {
        self.alignment = alignment
        self.spacing = spacing ?? defaultStackSpacing
        self.content = content()
    }
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
extension SVStack: _SContentContainer {
    public
    var children: [any SContent] {
        (content as? any GroupedContent)?.children
        ?? [content]
    }
}

public
protocol AnyVStack {
    var alignment: SHorizontalAlignment { get }
    var spacing: Float { get }
}
