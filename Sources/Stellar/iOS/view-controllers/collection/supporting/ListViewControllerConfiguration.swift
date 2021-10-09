//
//  ListViewControllerConfiguration.swift
//  
//
//  Created by Jesse Spencer on 3/2/21.
//

import Foundation
import UIKit

extension ListViewController {
    struct ListViewControllerConfiguration {
        
        /// Details for how multiselection should be configured, if at all.
        var multiselectionConfiguration: ListMultiselectionConfiguration = .init()
        
        // MARK: - sections
        var canCollapse: (_ item: RowType) -> Bool = { _ in false }
        var didCollapse: (_ item: RowType) -> Void = { _ in }
        
        /// Determines whether the section can be expanded when the header is tapped.
        ///
        /// This method is only called during normal mode. If you want expansion/collapse behavior during editing mode you must respond in the `canSelect(item: inSection:).` For more detail, see the docs for that method.
        var canExpand: (_ item: RowType) -> Bool = { _ in false }
        var didExpand: (_ item: RowType) -> Void = { _ in }
        
        // MARK: - reordering
        /// Determines whether the item can be reordered.
        var canReorder: (_ item: RowType) -> Bool = { _ in false }
        /// Informs that reordering has completed with the provided transaction which provides the changes.
        var didReorder: (_ transaction: NSDiffableDataSourceTransaction<SectionType, RowType>) -> Void = { _ in }
        
        // MARK: - swipe actions
        var leadingSwipeActions: (_ item: RowType) -> UISwipeActionsConfiguration? = { _ in nil }
        var trailingSwipeActions: (_ item: RowType) -> UISwipeActionsConfiguration? = { _ in nil }
        
        // MARK: - responding
        var initialFirstResponder: () -> RowType? = { nil }
        var subsequentFirstResponder: (_ responder: RowType) -> RowType? = { _ in nil }
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
}
