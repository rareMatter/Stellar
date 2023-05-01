//
//  SHStack.swift
//  
//
//  Created by Jesse Spencer on 10/18/21.
//

public
struct SHStack<C>: SPrimitiveContent, AnyHStack
where C : SContent {
    
    public
    let alignment: SVerticalAlignment
    public
    let spacing: Float
    
    let content: C
    
    public
    init(alignment: SVerticalAlignment = .center,
         spacing: Float? = nil,
         @SContentBuilder content: () -> C) {
        self.alignment = alignment
        self.spacing = spacing ?? defaultStackSpacing
        self.content = content()
    }
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
extension SHStack: _SContentContainer {
    public
    var children: [any SContent] {
        (content as? any GroupedContent)?.children
        ?? [content]
    }
}

public let defaultStackSpacing: Float = 8

public
protocol AnyHStack {
    var alignment: SVerticalAlignment { get }
    var spacing: Float { get }
}
