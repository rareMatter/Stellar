//
//  AnySContent.swift
//  
//
//  Created by Jesse Spencer on 5/16/21.
//

import Foundation

public
struct AnySContent: SPrimitiveContent {
    
    /// The type of the wrapped `SContent`.
    let type: Any.Type
    
    /// The name of the type constructor for the wrapped `SContent`.
    let typeConstructorName: String
    
    /// The wrapped `SContent`.
    let content: Any
    
    /// The type of the `body` of the wrapped `SContent`.
    let bodyType: Any.Type
    
    /// A closure which provides the `body` of the wrapped `SContent`.
    ///
    /// The only parameter is an instance of the corresponding `SContent`.
    /// The `content` property of this object is the corresponding instance.
    let bodyProvider: (Any) -> AnySContent
    
    public
    init<Content>(_ content: Content)
    where Content : SContent {
        if let anyContent = content as? AnySContent {
            self = anyContent
        }
        else {
            type = Content.self
            self.typeConstructorName = Stellar.typeConstructorName(self.type)
            self.content = content
            bodyType = Content.Body.self
            bodyProvider = { content in
                guard let content = content as? Content else {
                    fatalError()
                }
                return AnySContent(content)
            }
        }
    }
}

extension AnySContent: _SContentContainer {
    var children: [AnySContent] {
        (content as? _SContentContainer)?.children ?? []
    }
}
