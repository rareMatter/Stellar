//
//  ListReordering.swift
//  Stellar
//
//  Created by Jesse Spencer on 8/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

/// A type that is used by ListViewController during reordering events in order to communicate changes.
public
struct ListReorderingTransaction<SectionIdentifierType, ItemIdentifierType> where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable {
	public var initialSnapshot: ListDataDiffableSnapshot<SectionIdentifierType, ItemIdentifierType>
	public var finalSnapshot: ListDataDiffableSnapshot<SectionIdentifierType, ItemIdentifierType>
	
    public
	func sectionDifference() -> CollectionDifference<SectionIdentifierType> {
		self.finalSnapshot.sections.difference(from: self.initialSnapshot.sections)
	}
    public
	func itemDifference() -> CollectionDifference<ItemIdentifierType> {
		self.finalSnapshot.items().difference(from: self.initialSnapshot.items())
	}
	
	init(initialSnapshot: ListDataDiffableSnapshot<SectionIdentifierType, ItemIdentifierType>, finalSnapshot: ListDataDiffableSnapshot<SectionIdentifierType, ItemIdentifierType>) {
		self.initialSnapshot = initialSnapshot
		self.finalSnapshot = finalSnapshot
	}
}

