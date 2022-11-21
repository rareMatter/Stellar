//
//  ModifiedElement+_SContentContainer.swift
//  
//
//  Created by Jesse Spencer on 11/19/22.
//

// TODO: This may be unused.
extension ModifiedElement: _SContentContainer
where Content : SContent, Modifier : SContentModifier {
    var children: [any SContent] { [content] }
}
