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
    public
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

extension SButton: _SContentContainer {
    var children: [AnySContent] { [.init(content)] }
}

// MARK: - button type erasure
// FIXME: temp public
public
protocol AnyButton {
    var actionHandler: SIdentifiableContainer<() -> Void> { get }
}

extension SButton: AnyButton {}
