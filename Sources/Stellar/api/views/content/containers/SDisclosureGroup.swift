//
//  SDisclosureGroup.swift
//  
//
//  Created by Jesse Spencer on 10/5/21.
//

import Foundation

public
struct SDisclosureGroup<Label, Content>: SPrimitiveContent
where Label : SContent, Content : SContent {
    
    @SState
    private
    var isExpanded: Bool = false
    
    let isExpandedBinding: SBinding<Bool>?
    
    let label: Label
    let content: () -> Content
    
    public
    init(@SContentBuilder content: @escaping () -> Content,
         @SContentBuilder label: () -> Label) {
        isExpandedBinding = nil
        self.label = label()
        self.content = content
    }
    
    public
    init(isExpanded: SBinding<Bool>,
         @SContentBuilder content: @escaping () -> Content,
         @SContentBuilder label: () -> Label) {
        isExpandedBinding = isExpanded
        self.label = label()
        self.content = content
    }
}
