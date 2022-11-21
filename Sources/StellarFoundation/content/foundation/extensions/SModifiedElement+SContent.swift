//
//  SModifiedElement+SContent.swift
//  
//
//  Created by Jesse Spencer on 11/14/22.
//

// MARK: content and primitive content conformance
extension ModifiedElement: SContent, SPrimitiveContent
where Content : SContent, Modifier : SContentModifier {}

// MARK: modifier chains
extension ModifiedElement: SContentModifier
where Content : SContentModifier, Modifier : SContentModifier {}
