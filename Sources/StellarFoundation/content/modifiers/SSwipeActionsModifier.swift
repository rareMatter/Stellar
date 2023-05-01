//
//  SSwipeActionsModifier.swift
//  
//
//  Created by Jesse Spencer on 11/22/21.
//

struct SSwipeActionsModifier<Actions>: SContentModifier
where Actions : SContent {
    let actions: Actions
    let edge: SHorizontalEdge
    let allowsFullSwipe: Bool
    
    func body(content: any SContent) -> some SContent {
        SwipeActionsModifierContainer(actions: actions,
                                      edge: edge,
                                      allowsFullSwipe: allowsFullSwipe)
    }
}

struct SwipeActionsModifierContainer<Actions>: SPrimitiveContent
where Actions : SContent {
    let actions: Actions
    let edge: SHorizontalEdge
    let allowsFullSwipe: Bool
    
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}
extension SwipeActionsModifierContainer: _SContentContainer {
    var children: [any SContent] { [actions] }
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
