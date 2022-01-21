//
//  SSwipeActionsModifier.swift
//  
//
//  Created by Jesse Spencer on 11/22/21.
//

// TODO: WIP.

import Foundation

struct SSwipeActionsModifier<Actions>: SContentModifier
where Actions : SContent {
    typealias Body = Never
    
    let actions: Actions
    let edge: SHorizontalEdge
    let allowsFullSwipe: Bool
}

public
enum SHorizontalEdge: Equatable, Hashable {
    case leading
    case trailing
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
