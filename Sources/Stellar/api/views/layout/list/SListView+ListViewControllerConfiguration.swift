//
//  SListView+ListViewControllerConfiguration.swift
//  
//
//  Created by Jesse Spencer on 3/27/21.
//

import Foundation

extension SListView: ListViewControllerConfiguration {
    
    // MARK: - taps
    func canTap(item: ItemType, inSection section: SectionType) -> Bool {
        tapHandler != nil
    }
    func didTap(item: ItemType, inSection section: SectionType) {
        tapHandler?(item, section)
    }
    
    // MARK: - selection
    func canSelect(item: ItemType, inSection section: SectionType) -> Bool {
        selectionHandler != nil
    }
    func didSelect(item: ItemType, inSection section: SectionType) {
        selectionHandler?(item, section)
    }
    
    var multiselectionConfiguration: ListMultiselectionConfiguration {
        .init()
    }
    
    // MARK: - reordering
    func canReorder(item: ItemType) -> Bool {
        canReorderItemHandler?(item) ?? false
    }
    func didReorder(with transaction: ListReorderingTransaction<SectionType, ItemType>) {
        didReorderHandler?(transaction)
    }
    
    func canInsertItemIntoSection(item: ItemType, section: SectionType) -> Bool {
        canInsertItemIntoSectionHandler?(item, section) ?? false
    }
    func didInsertItemIntoSection(item: ItemType, section: SectionType) {
        didInsertItemIntoSectionHandler?(item, section)
    }
    
    // MARK: - section behaviors
    func canCollapse(section: SectionType, withHeader header: ItemType) -> Bool {
        canCollapseSectionHandler?(section, header) ?? false
    }
    func didCollapse(section: SectionType, withHeader header: ItemType) {
        didCollapseSectionHandler?(section, header)
    }
    
    func canExpand(section: SectionType, withHeader header: ItemType) -> Bool {
        canExpandSectionHandler?(section, header) ?? false
    }
    func didExpand(section: SectionType, withHeader header: ItemType) {
        didExpandSectionHandler?(section, header)
    }
    
    // MARK: - swipe actions
    func leadingSwipeActions(for item: ItemType) -> ListSwipeActionsConfiguration? {
        leadingSwipeActionsHandler?(item)
    }
    func trailingSwipeActions(for item: ItemType) -> ListSwipeActionsConfiguration? {
        trailingSwipeActionsHandler?(item)
    }
    
    // MARK: - reponding
    func initialFirstResponder() -> ItemType? {
        initialFirstResponderHandler?()
    }
    func subsequentFirstResponder(following responder: ItemType) -> ItemType? {
        subsequentFirstResponderHandler?(responder)
    }
}
