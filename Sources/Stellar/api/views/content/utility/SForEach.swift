//
//  SForEach.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Foundation
#warning("TODO: SForEach has not been implemented for rendering.")
public
struct SForEach<Data, ID, Content>: SPrimitiveContent
where Data: RandomAccessCollection, ID: Hashable, Content: SContent {
    
    let data: Data
    let id: KeyPath<Data.Element, ID>
    
    public
    let content: (Data.Element) -> Content
    
    public
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         @SContentBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.id = id
        self.content = content
    }    
}

// MARK: - initializers

public
extension SForEach
where Data.Element: Identifiable, ID == Data.Element.ID {
    
    init(_ data: Data,
         @SContentBuilder content: @escaping (Data.Element) -> Content) {
        self.init(data, id: \.id, content: content)
    }
}

// MARK: - protocol conformance

extension SForEach: _SContentContainer {
    var children: [AnySContent] {
        data.map { AnySContent(SIdentifiableContent(content($0), id: $0[keyPath: id])) }
    }
}

