//
//  SIdentifiableContent.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

// TODO: This may be better formed by not being primitive and instead simply injecting the ID into the environment.
public
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
    var children: [any SContent] { [content] }
}
extension SIdentifiableContent: AnySIdentifiableContent {
    public
    var anyIdentifier: any Hashable { id }
    public
    var anyContent: any SContent { content }
}
