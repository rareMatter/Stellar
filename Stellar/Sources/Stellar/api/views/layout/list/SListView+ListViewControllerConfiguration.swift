//
//  SListView+ListViewControllerConfiguration.swift
//  
//
//  Created by Jesse Spencer on 3/27/21.
//

import Foundation

extension SListView: ListViewControllerConfiguration {
    
    var multiselectionConfiguration: ListMultiselectionConfiguration {
        .init()
    }
    
    // MARK: - reordering
    func canReorder(item: ItemType) -> Bool {
        false
    }
    func didReorder(with transaction: ListReorderingTransaction<SectionType, ItemType>) {
        
    }
    
    func canInsertItemIntoSection(item: ItemType, section: SectionType) -> Bool {
        false
    }
    func didInsertItemIntoSection(item: ItemType, section: SectionType) {
        
    }
    
    // MARK: - section behaviors
    func canCollapse(section: SectionType, withHeader header: ItemType) -> Bool {
        false
    }
    func didCollapse(section: SectionType, withHeader header: ItemType) {
        
    }
    
    func canExpand(section: SectionType, withHeader header: ItemType) -> Bool {
        false
    }
    func didExpand(section: SectionType, withHeader header: ItemType) {
        
    }
    
    // MARK: - swipe actions
    func leadingSwipeActions(for item: ItemType) -> ListSwipeActionsConfiguration? {
        nil
    }
    func trailingSwipeActions(for item: ItemType) -> ListSwipeActionsConfiguration? {
        nil
    }
    
    // MARK: - reponding
    func initialFirstResponder() -> ItemType? {
        initialFirstResponderHandler?()
    }
    func subsequentFirstResponder(following responder: ItemType) -> ItemType? {
        subsequentFirstResponderHandler?(responder)
    }
}
