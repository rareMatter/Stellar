//
//  ListConfiguration.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 8/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

public
struct ListConfiguration<SectionIdentifier, ItemIdentifier> where SectionIdentifier : Hashable, ItemIdentifier : Hashable {
	
	public var selection: Selection = .init()
    public var reordering: Reordering = .init()
    public var sections: Sections = .init()
    public var swipeActions: SwipeActions = .init()
    public var responding: Responding = .init()

    public
	struct Selection {
        public typealias ShouldSelect = (_ item: ItemIdentifier, _ listMode: ListMode) -> Bool
        public typealias WillSelect = (_ item: ItemIdentifier) -> Void
        public typealias DidSelect = (_ item: ItemIdentifier, _ listMode: ListMode, _ sender: UIViewController) -> Void
		
		public var shouldSelect: ShouldSelect
        public var willSelect: WillSelect
        public var didSelect: DidSelect
        
        /// Whether the list controller should install a mutliselection pan gesture when in editing mode, to allow for quick batch selection.
        public var useMultiselectionPanGesture = true
        /// The size of the pan gesture area.
        public var multiselectionPanGestureRegionSize = 65
        /// The side of the screen the gesture region will be installed.
        public var multiselectionPanGestureEdge: Edge = .trailing
        public enum Edge {
            case leading, trailing
        }
        
        public
        init(shouldSelect: @escaping ShouldSelect = {_,_ in true }, willSelect: @escaping WillSelect = {_ in }, didSelect: @escaping DidSelect = {_,_,_  in }) {
            self.shouldSelect = shouldSelect
            self.willSelect = willSelect
            self.didSelect = didSelect
        }
	}
    public
	struct Reordering {
        public typealias CanReorder = (_ item: ItemIdentifier) -> Bool
		
        public typealias CanInsertItemIntoSection = (_ item: ItemIdentifier, _ intoSection: SectionIdentifier) -> Bool
        public typealias DidInsertItemIntoSection = (_ item: ItemIdentifier, _ intoSection: SectionIdentifier) -> Void

        public typealias WillReorder = () -> Void
        public typealias DidReorder = (_ transaction: ListReorderingTransaction<SectionIdentifier, ItemIdentifier>) -> Void
		
        public var canReorder: CanReorder
		
        public var canInsertItemIntoSection: CanInsertItemIntoSection
        public var didInsertItemIntoSection: DidInsertItemIntoSection

        public var willReorder: WillReorder
        public var didReorder: DidReorder
        
        public
        init(canReorder: @escaping CanReorder = {_ in false }, canInsertItemIntoSection: @escaping CanInsertItemIntoSection = {_,_ in false }, didInsertItemIntoSection: @escaping DidInsertItemIntoSection = {_,_ in }, willReorder: @escaping WillReorder = {}, didReorder: @escaping DidReorder = {_ in}) {
            self.canReorder = canReorder
            self.canInsertItemIntoSection = canInsertItemIntoSection
            self.didInsertItemIntoSection = didInsertItemIntoSection
            self.willReorder = willReorder
            self.didReorder = didReorder
        }
	}
    public
	struct Sections {
        public typealias ShouldCollapse = (_ section: SectionIdentifier, _ withHeader: ItemIdentifier, _ inListMode: ListMode) -> Bool
        public typealias ShouldExpand = (_ section: SectionIdentifier, _ withHeader: ItemIdentifier, _ inListMode: ListMode) -> Bool
		
        public typealias WillCollapse = (_ section: SectionIdentifier, _ withHeader: ItemIdentifier, _ inListMode: ListMode) -> Void
        public typealias WillExpand = (_ section: SectionIdentifier, _ withHeader: ItemIdentifier, _ inListMode: ListMode) -> Void
		
        public var shouldCollapse: ShouldCollapse
        public var shouldExpand: ShouldExpand
		
        public var willCollapse: WillCollapse
        public var willExpand: WillExpand
        
        public
        init(shouldCollapse: @escaping ShouldCollapse = {_,_,_ in false }, shouldExpand: @escaping ShouldExpand = {_,_,_ in false }, willCollapse: @escaping WillCollapse = {_,_,_ in }, willExpand: @escaping WillExpand = {_,_,_ in }) {
            self.shouldCollapse = shouldCollapse
            self.shouldExpand = shouldExpand
            self.willCollapse = willCollapse
            self.willExpand = willExpand
        }
	}
    public
	struct SwipeActions {
        public typealias Leading = (_ item: ItemIdentifier, _ sender: UIViewController) -> ListSwipeActionsConfiguration?
        public typealias Trailing = (_ item: ItemIdentifier, _ sender: UIViewController) -> ListSwipeActionsConfiguration?
		
        public var leading: Leading
        public var trailing: Trailing
        
        public
        init(leading: @escaping Leading = {_,_ in nil}, trailing: @escaping Trailing = {_,_ in nil}) {
            self.leading = leading
            self.trailing = trailing
        }
	}
    public
	struct Responding {
		/// Returns an Item which should be made first responder upon initial list appearance. This Item will not become first responder again.
        public var initialFirstResponder: (() -> ItemIdentifier?)?

		/// Returns an item identifier which should be made first responder after the provided first responder has resigned.
		///
		///  In order for this behavior to be enabled, cells which correspond to first responder item identifiers must conform to ResponderNotifier. The list controller will subscribe to publishers from these cells and use them to coordinate responding behaviors.
        public var subsequentFirstResponder: ((_ after: ItemIdentifier) -> ItemIdentifier?)?
        
        public
        init(initialFirstResponder: (() -> ItemIdentifier?)? = nil, subsequentFirstResponder: ((ItemIdentifier) -> ItemIdentifier?)? = nil) {
            self.initialFirstResponder = initialFirstResponder
            self.subsequentFirstResponder = subsequentFirstResponder
        }
	}
}

// MARK: - creation
public extension ListConfiguration {
    static func standard() -> ListConfiguration { Self.init() }
}
