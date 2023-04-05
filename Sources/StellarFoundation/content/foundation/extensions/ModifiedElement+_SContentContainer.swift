//
//  ModifiedElement+_SContentContainer.swift
//  
//
//  Created by Jesse Spencer on 11/19/22.
//

import utilities

// TODO: This may be unused.
extension ModifiedElement: CollectionBox, _SContentContainer
where Content : SContent, Modifier : SContentModifier {
    public var children: [any SContent] { [content] }
}
