//
//  SModifiedElement+SContent.swift
//  
//
//  Created by Jesse Spencer on 11/14/22.
//

// MARK: content and primitive content conformance
public
extension ModifiedElement: SContent, SPrimitiveContent
where Content : SContent, Modifier : SContentModifier {}

// MARK: modifier chains
public
extension ModifiedElement: ElementModifier, SContentModifier
where Content : SContentModifier, Modifier : SContentModifier {
    public func body(content: Self.Content) -> Self.Body {
        fatalError()
    }
}
