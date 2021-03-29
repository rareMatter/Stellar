//
//  ListViewControllerConfiguration.swift
//  
//
//  Created by Jesse Spencer on 3/2/21.
//

import Foundation

protocol ListViewControllerConfiguration {
    associatedtype SectionType: Hashable
    associatedtype ItemType: Hashable
    
    // MARK: - taps
    /** Determines whether the item responds to taps as a button.
    */
    func canTap(item: ItemType, inSection section: SectionType) -> Bool
    func didTap(item: ItemType, inSection section: SectionType)
    
    // MARK: - editing selection
    /** Determines whether the item can be set to a selected state during editing.
     
    The item can be a section header. If you want headers to be expandable/collapsable during editing, you must manually apply this behavior by responding here and updating the snapshot accordingly.
     */
    func canSelect(item: ItemType, inSection section: SectionType) -> Bool
    /// Informs that the item has been set to a selected state.
    func didSelect(item: ItemType, inSection section: SectionType)
    
    /// Details for how multiselection should be configured, if at all.
    var multiselectionConfiguration: ListMultiselectionConfiguration { get }
    
    // MARK: - sections
    func canCollapse(section: SectionType, withHeader header: ItemType) -> Bool
    func didCollapse(section: SectionType, withHeader header: ItemType)
    
    /// Determines whether the section can be expanded when the header is tapped.
    ///
    /// This method is only called during normal mode. If you want expansion/collapse behavior during editing mode you must respond in the `canSelect(item: inSection:).` For more detail, see the docs for that method.
    func canExpand(section: SectionType, withHeader header: ItemType) -> Bool
    func didExpand(section: SectionType, withHeader header: ItemType)
    
    // MARK: - reordering
    /// Determines whether the item can be reordered.
    func canReorder(item: ItemType) -> Bool
    /// Informs that reordering has completed with the provided transaction which provides the changes.
    func didReorder(with transaction: ListReorderingTransaction<SectionType, ItemType>)
    
    /// Determines whether the item is allowed to be inserted into the section.
    func canInsertItemIntoSection(item: ItemType, section: SectionType) -> Bool
    /// Informs that the item was inserted into the section.
    func didInsertItemIntoSection(item: ItemType, section: SectionType)
    
    // MARK: - swipe actions
    func leadingSwipeActions(for item: ItemType) -> ListSwipeActionsConfiguration?
    func trailingSwipeActions(for item: ItemType) -> ListSwipeActionsConfiguration?
    
    // MARK: - responding
    func initialFirstResponder() -> ItemType?
    func subsequentFirstResponder(following responder: ItemType) -> ItemType?
}

struct ListMultiselectionConfiguration {
    /// Whether the list controller should install a mutliselection pan gesture when in editing mode, to allow for quick batch selection.
    var useMultiselectionPanGesture = true
    /// The size of the pan gesture area.
    var multiselectionPanGestureRegionSize = 65
    /// The side of the screen the gesture region will be installed.
    var multiselectionPanGestureEdge: Edge = .trailing
    
    enum Edge {
        case leading, trailing
    }
}
