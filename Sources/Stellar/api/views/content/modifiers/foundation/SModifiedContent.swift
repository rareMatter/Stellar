//
//  SModifiedContent.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

import Foundation

// TODO: Rename to SModifiedElement.
public
struct SModifiedContent<Content, Modifier> {
    public typealias Body = Never
    public let content: Content
    public let modifier: Modifier
    
    public
    init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
}

// MARK: content and primitive content conformance
extension SModifiedContent: SContent, SPrimitiveContent
where Content : SContent, Modifier : SContentModifier {}

// MARK: modifier chains
extension SModifiedContent: SContentModifier
where Content : SContentModifier, Modifier : SContentModifier {}

// MARK: Content container
// TODO: This may be unused.
extension SModifiedContent: _SContentContainer
where Content : SContent, Modifier : SContentModifier {
    var children: [AnySContent] { [.init(content)] }
}

// TODO: Revise to be AnyModifiedElement.
// FIXME: temp public
// MARK: Type-erased recognition
public
protocol SomeModifiedContent {}
extension SModifiedContent: SomeModifiedContent {}

// MARK: content modification function
public
extension SContent {
    
    func modifier<T>(_ modifier: T) -> SModifiedContent<Self, T> {
        .init(content: self, modifier: modifier)
    }
}
