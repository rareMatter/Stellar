//
//  AnySContent.swift
//  
//
//  Created by Jesse Spencer on 5/16/21.
//

@available(*, deprecated, message: "Use compiler support instead.")
public
struct AnySContent: SPrimitiveContent {
    
    /// The type of the wrapped `SContent`.
    let type: Any.Type
    
    /// The name of the type constructor for the wrapped `SContent`.
    let typeConstructorName: String
    
    /// The wrapped `SContent`.
    ///
    /// This is a `var` to be accessible using a ReferenceWritableKeyPath.
    var content: Any
    
    /// The type of the `body` of the wrapped `SContent`.
    let bodyType: Any.Type
    
    /// A closure which provides the `body` of the wrapped `SContent`.
    ///
    /// The only parameter is an instance of the corresponding `SContent`.
    /// The `content` property of this object is the corresponding instance.
    let bodyProvider: (Any) -> AnySContent
    
    public
    init<Content>(_ erasingContent: Content)
    where Content : SContent {
        if let anyContent = erasingContent as? AnySContent {
            self = anyContent
        }
        else {
            type = Content.self
            self.typeConstructorName = StellarFoundation.typeConstructorName(Content.self)
            self.content = erasingContent
            bodyType = Content.Body.self
            bodyProvider = { content in
                guard let content = content as? Content else {
                    fatalError()
                }
                return AnySContent(content.body)
            }
        }
    }
}

extension AnySContent: _SContentContainer {
    var children: [any SContent] {
        (content as? _SContentContainer)?.children ?? []
    }
}
