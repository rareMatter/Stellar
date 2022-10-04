//
//  SHStack.swift
//  
//
//  Created by Jesse Spencer on 10/18/21.
//

import Foundation

public
struct SHStack<Content>: SPrimitiveContent
where Content : SContent {
    
    public let alignment: SVerticalAlignment
    public let spacing: Float
    public let content: Content
    
    public
    init(alignment: SVerticalAlignment = .center,
         spacing: Float? = nil,
         @SContentBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing ?? defaultStackSpacing
        self.content = content()
    }
}
extension SHStack: _SContentContainer {
    var children: [AnySContent] {
        (content as? GroupedContent)?.children
        ?? [AnySContent(content)]
    }
}

public let defaultStackSpacing: Float = 8

public
enum SVerticalAlignment: Hashable {
    case top
    case center
    case bottom
}

// FIXME: temp public
public
protocol AnyHStack {
    var alignment: SVerticalAlignment { get }
    var spacing: Float { get }
}
extension SHStack: AnyHStack {}
