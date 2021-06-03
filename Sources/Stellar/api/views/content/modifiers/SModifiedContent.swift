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

extension SModifiedContent: SContent, SPrimitiveContent, _SContentContainer
where Content : SContent, Modifier : SContentModifier {
    
    public
    var children: [AnySContent] {
        [AnySContent(content)]
    }
}
