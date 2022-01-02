//
//  SButton.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SButton<Content>: SPrimitiveContent
where Content : SContent {
    let actionHandler: SIdentifiableContainer<() -> Void>
    let content: Content
}

public
extension SButton {

    init(action: @escaping () -> Void,
         content: () -> Content) {
        self.actionHandler = .init(action)
        self.content = content()
    }
}
