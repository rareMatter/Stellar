//
//  SListView+Configuration.swift
//  
//
//  Created by Jesse Spencer on 3/27/21.
//

import Foundation

public
extension SListView {
    
    // MARK: - taps
    func onTap(_ handler: @escaping TapHandler) -> Self {
        var modified = self
        modified.tapHandler = handler
        return modified
    }
    
    // MARK: - editing selection
    func onSelect(_ handler: @escaping SelectionHandler) -> Self {
        var modified = self
        modified.selectionHandler = handler
        return modified
    }
    
    // MARK: - reordering
    func canReorder(_ handler: @escaping CanReorderItemHandler) -> Self {
        var modified = self
        modified.canReorderItemHandler = handler
        return modified
    }
    func didReorder(_ handler: @escaping DidReorderHandler) -> Self {
        var modified = self
        modified.didReorderHandler = handler
        return modified
    }
    
    func canInsertItemIntoSection(_ handler: @escaping CanInsertItemIntoSectionHandler) -> Self {
        var modified = self
        modified.canInsertItemIntoSectionHandler = handler
        return modified
    }
    func didInsertItemItemSection(_ handler: @escaping DidInsertItemIntoSectionHandler) -> Self {
        var modified = self
        modified.didInsertItemIntoSectionHandler = handler
        return modified
    }
    
    func canCollapseSection(_ handler: @escaping CanCollapseSectionHandler) -> Self {
        var modified = self
        modified.canCollapseSectionHandler = handler
        return modified
    }
    func didCollapseSection(_ handler: @escaping DidCollapseSectionHandler) -> Self {
        var modified = self
        modified.didCollapseSectionHandler = handler
        return modified
    }
    func canExpandSection(_ handler: @escaping CanExpandSectionHandler) -> Self {
        var modified = self
        modified.canExpandSectionHandler = handler
        return modified
    }
    func didExpandSection(_ handler: @escaping DidExpandSectionHandler) -> Self {
        var modified = self
        modified.didExpandSectionHandler = handler
        return modified
    }
    
    func leadingSwipeActions(_ handler: @escaping SwipeActionsHandler) -> Self {
        var modified = self
        modified.leadingSwipeActionsHandler = handler
        return modified
    }
    func trailingSwipeActions(_ handler: @escaping SwipeActionsHandler) -> Self {
        var modified = self
        modified.trailingSwipeActionsHandler = handler
        return modified
    }
    
    func initialFirstResponder(_ handler: @escaping InitialFirstResponderHandler) -> Self {
        var modified = self
        modified.initialFirstResponderHandler = handler
        return modified
    }
    func subsequentFirstResponder(_ handler: @escaping SubsequentFirstResponderHandler) -> Self {
        var modified = self
        modified.subsequentFirstResponderHandler = handler
        return modified
    }
}
