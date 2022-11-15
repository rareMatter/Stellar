//
//  SIdentifiableContent.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Foundation

// TODO: This may be better formed by not being primitive and instead simply injecting the ID into the environment.
struct SIdentifiableContent<Content, ID>: SPrimitiveContent
where Content: SContent, ID: Hashable {
    let content: Content
    let id: ID
    
    init(_ content: Content, id: ID) {
        self.content = content
        self.id = id
    }
    
    /*
    var body: some SContent {
        content
        // TODO: Needs environment ID.
            // .environment(\.id, AnyHashable(id))
    }
     */
}
extension SIdentifiableContent: _SContentContainer {
    var children: [AnySContent] { [.init(content)] }
}
extension SIdentifiableContent: AnySIdentifiableContent {
    var anyIdentifier: AnyHashable { .init(id) }
    var anyContent: AnySContent { .init(content) }
}
