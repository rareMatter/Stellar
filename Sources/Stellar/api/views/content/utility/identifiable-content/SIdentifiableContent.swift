//
//  SIdentifiableContent.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Foundation

struct SIdentifiableContent<Content, ID>: SContent, AnySIdentifiableContent
where Content: SContent, ID: Hashable {
    let content: Content
    let id: ID
    
    var anyIdentifier: AnyHashable { AnyHashable(id) }
    var anyContent: AnySContent { AnySContent(content) }
    
    init(_ content: Content, id: ID) {
        self.content = content
        self.id = id
    }
    
    var body: some SContent {
        content
        // TODO: Needs environment ID.
            // .environment(\.id, AnyHashable(id))
    }
}

// MARK: Conditional _SSectionContainer conformance
extension SIdentifiableContent: _SSectionContainer
where Content : _SSectionContainer {
    
    func makeListRow() -> AnySContent {
        content.makeListRow()
    }
}
