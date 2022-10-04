//
//  SSwipeActionsModifier.swift
//  
//
//  Created by Jesse Spencer on 11/22/21.
//

import Foundation

struct SSwipeActionsModifier<Actions>: SContentModifier
where Actions : SContent {
    let actions: Actions
    let edge: SHorizontalEdge
    let allowsFullSwipe: Bool
    
    func body(content: Content) -> some SContent {
        SwipeActionsModifierContainer(actions: actions,
                                      edge: edge,
                                      allowsFullSwipe: allowsFullSwipe)
    }
}

public
enum SHorizontalEdge: Equatable, Hashable {
    case leading
    case trailing
}

struct SwipeActionsModifierContainer<Actions>: SPrimitiveContent
where Actions : SContent {
    let actions: Actions
    let edge: SHorizontalEdge
    let allowsFullSwipe: Bool
}
extension SwipeActionsModifierContainer: _SContentContainer {
    var children: [AnySContent] { [.init(actions)] }
}

public
extension SContent {
    
    func swipeActions<T>(edge: SHorizontalEdge = .trailing,
                         allowsFullSwipe: Bool = true,
                         content: () -> T) -> some SContent
    where T : SContent {
        modifier(SSwipeActionsModifier(actions: content(),
                                       edge: edge,
                                       allowsFullSwipe: allowsFullSwipe))
    }
}
