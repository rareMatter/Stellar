//
//  SModifiedContent.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

import Foundation

public
struct SModifiedContent<Content, Modifier> {
    public typealias Body = Never
    let content: Content
    let modifier: Modifier
}

// MARK: - content and primitive content conformance
extension SModifiedContent: SContent, SPrimitiveContent
where Content : SContent, Modifier : SContentModifier {}

// MARK: - content modification method
public
extension SContent {
    
    func modifier<T>(_ modifier: T) -> SModifiedContent<Self, T> {
        .init(content: self, modifier: modifier)
    }
}
