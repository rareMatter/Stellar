//
//  ListDataDiffableSnapshot.swift
//  Stellar
//
//  Created by Jesse Spencer on 8/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

public
struct ListDataDiffableSnapshot<SectionIdentifierType, ItemIdentifierType>: Equatable where SectionIdentifierType : Hashable, ItemIdentifierType : Hashable {
	/// The sections in the snapshot.
	private(set) var _sections: [SectionIdentifierType] = []
    public var sections: [SectionIdentifierType] { _sections }
    
	internal var sectionMetadata: [SectionIdentifierType : SectionMetadata] = [:]
	internal var itemMetadata: [ItemIdentifierType : ItemMetadata] = [:]
	
	internal struct SectionMetadata: Hashable {
		var items: [ItemIdentifierType] = []
		var header: ItemIdentifierType? = nil
		var isCollapsed: Bool = false
		var needsReloading = false
	}
	internal struct ItemMetadata: Hashable {
		var needsReloading = false
	}
}

// MARK: creation
public extension ListDataDiffableSnapshot {
    static func snapshot() -> Self { .init() }
}

// MARK: operations
public
extension ListDataDiffableSnapshot {
	
	// -- appending
	
	mutating func appendItems(_ items: [ItemIdentifierType], to section: SectionIdentifierType) {
		precondition(self._sections.contains(section))

		var sectionData = sectionMetadata[section] ?? .init()
		sectionData.items.append(contentsOf: items)
		sectionMetadata[section] = sectionData
	}

	/** Appends items to an existing section.
	- Parameters:
	- items: The items which will be appended in order to the specified section.
	- section: The section which will contain the items.
	- includingHeaderItem: Whether the provided items include a header value at the beginning of the collection.
	- Returns: An updated snapshot.
	- Note: If the receiver does not contain the section an exception is thrown.
	*/
	nonmutating func appendingItems(_ items: [ItemIdentifierType], toSection section: SectionIdentifierType) -> Self {
		var snapshot = self
		snapshot.appendItems(items, to: section)
		return snapshot
	}
	
	mutating func appendSection(_ section: SectionIdentifierType, includingHeaderItem: Bool = false, withItems items: [ItemIdentifierType] = [], isCollapsed: Bool = false) {
		if sectionMetadata[section] != nil {
			debugPrint("Warning: appending a section to a snapshot which already contains the section. This will overwrite existing section state.")
		}
		
		var sectionData = sectionMetadata[section] ?? .init()
		sectionData.items.append(contentsOf: items)
		sectionData.isCollapsed = isCollapsed
		
		if includingHeaderItem {
			guard let headerItem = items.first else {
				preconditionFailure("A header item can not be set when no items are provided. The section must be created with at least 1 item in order to set a section header item.")
			}
			sectionData.header = headerItem
		}
		
		_sections.append(section)
		sectionMetadata[section] = sectionData
	}

	/// Appends the section to the snapshot optionally including a collection of items whose first instance can be marked as a header for the section.
	/// - Parameters:
	///   - section: The section to append.
	///   - includingHeaderItem: Whether the snapshot should mark the first item in the collection as the section header.
	///   - items: The items to append to the section.
	///   - collapsed: Whether the section is collapsed.
	/// - Returns: A value with updated properties.
	/// - Note: This is the only opportunity to mark the section as having a header item. If the header item flag is true and there is not at least 1 item in the collection, an error is thrown.
	nonmutating func appendingSection(_ section: SectionIdentifierType, includingHeaderItem: Bool = false, withItems items: [ItemIdentifierType] = [], isCollapsed: Bool = false) -> Self {
		var snapshot = self
		snapshot.appendSection(section, includingHeaderItem: includingHeaderItem, withItems: items, isCollapsed: isCollapsed)
		return snapshot
	}
	
	mutating func appendSections(_ sections: [SectionIdentifierType], includingHeaderItem: (SectionIdentifierType) -> Bool = {_ in false }, withItems itemProvider: (SectionIdentifierType) -> [ItemIdentifierType] = {_ in []}, isCollapsed: (SectionIdentifierType) -> Bool = {_ in false }) {
		sections.forEach { (section) in
			appendSection(section,
						  includingHeaderItem: includingHeaderItem(section),
						  withItems: itemProvider(section),
						  isCollapsed: isCollapsed(section))
		}
	}

	/** Add many sections at once and specify the items and section state using callbacks.
	
	
	*/
	nonmutating func appendingSections(_ sections: [SectionIdentifierType], includingHeaderItem: (SectionIdentifierType) -> Bool = {_ in false }, withItems itemProvider: (SectionIdentifierType) -> [ItemIdentifierType] = {_ in []}, isCollapsed: (SectionIdentifierType) -> Bool = {_ in false }) -> Self {
		var snapshot = self
		snapshot.appendSections(sections,
							 includingHeaderItem: includingHeaderItem,
							 withItems: itemProvider,
							 isCollapsed: isCollapsed)
		return snapshot
	}
	
	// -- insertion
	
	mutating func insertItems(_ items: [ItemIdentifierType], after item: ItemIdentifierType) {
		guard let section = sectionContaining(item) else {
			fatalError("Item does not exist in snapshot: \(item)")
		}
		guard var sectionData = sectionMetadata[section],
			let itemIndex = sectionData.items.firstIndex(of: item) else {
				fatalError()
		}
		let insertionIndex = min((itemIndex + 1), sectionData.items.endIndex)
		var updatedItems = sectionData.items
		updatedItems.insert(contentsOf: items, at: insertionIndex)
		
		sectionData.items = updatedItems
		sectionMetadata[section] = sectionData
	}
	mutating func insertItems(_ items: [ItemIdentifierType], before item: ItemIdentifierType) {
		guard let section = sectionContaining(item) else {
			fatalError("Item does not exist in snapshot: \(item)")
		}
		guard var sectionData = sectionMetadata[section],
			let itemIndex = sectionData.items.firstIndex(of: item) else {
				fatalError()
		}
		var updatedItems = sectionData.items
		updatedItems.insert(contentsOf: items, at: itemIndex)
		
		sectionData.items = updatedItems
		sectionMetadata[section] = sectionData
	}
	/*
	nonmutating func inserting(_ items: [ItemIdentifierType], before item: ItemIdentifierType) -> Self {
		var value = self
		// TODO:
		return value
	}
	nonmutating func inserting(_ items: [ItemIdentifierType], after item: ItemIdentifierType) -> Self {
		var value = self
		// TODO:
		return value
	}
	*/
	
	mutating func insertSections(_ insertingSections: [SectionIdentifierType], before section: SectionIdentifierType) {
		guard let sectionIndex = _sections.firstIndex(of: section) else {
			fatalError("section does not exist in snapshot")
		}
		_sections.insert(contentsOf: insertingSections, at: sectionIndex)
	}
	mutating func insertSections(_ insertingSections: [SectionIdentifierType], after section: SectionIdentifierType) {
		guard let sectionIndex = _sections.firstIndex(of: section) else {
			fatalError("section does not exist in snapshot")
		}
		_sections.insert(contentsOf: insertingSections, at: min(sectionIndex + 1, _sections.endIndex))
	}
	// -- moving
	
	mutating func move(_ movingSections: [SectionIdentifierType], after section: SectionIdentifierType) {
		var filteredSections = _sections.filter { !movingSections.contains($0) }
		guard let sectionIndex = filteredSections.firstIndex(of: section) else {
			fatalError()
		}
		let insertionIndex = min((sectionIndex + 1), filteredSections.endIndex)
		filteredSections.insert(contentsOf: movingSections, at: insertionIndex)
		_sections = filteredSections
	}
	mutating func move(_ movingSections: [SectionIdentifierType], before section: SectionIdentifierType) {
		var filteredSections = _sections.filter { !movingSections.contains($0) }
		guard let sectionIndex = filteredSections.firstIndex(of: section) else {
			fatalError()
		}
		filteredSections.insert(contentsOf: movingSections, at: sectionIndex)
		_sections = filteredSections
	}
	
	mutating func moveItems(_ items: [ItemIdentifierType], after item: ItemIdentifierType) {
		deleteItems(items)
		insertItems(items, after: item)
	}
	mutating func moveItems(_ items: [ItemIdentifierType], before item: ItemIdentifierType) {
		deleteItems(items)
		insertItems(items, before: item)
	}
	/*
	nonmutating func moving(_ sections: [SectionIdentifierType], after section: SectionIdentifierType) -> Self {
		var value = self
		// TODO:
		return value
	}
	nonmutating func moving(_ sections: [SectionIdentifierType], before section: SectionIdentifierType) -> Self {
		var value = self
		// TODO:
		return value
	}
	*/
	// -- reloading
	
	mutating func reloadItems(_ items: [ItemIdentifierType]) {
		for item in items {
			var updatedData = itemMetadata[item] ?? ItemMetadata()
			updatedData.needsReloading = true
			itemMetadata[item] = updatedData
		}
	}
	mutating func reloadSections(_ sections: [SectionIdentifierType]) {
		for section in sections {
			var updatedData = sectionMetadata[section] ?? SectionMetadata()
			updatedData.needsReloading = true
			sectionMetadata[section] = updatedData
		}
	}
	/*
	nonmutating func reloadingItems(_ items: [ItemIdentifierType]) -> Self {
		var value = self
		// TODO:
		return value
	}
	nonmutating func reloadingSections(_ items: [ItemIdentifierType]) -> Self {
		var value = self
		// TODO:
		return value
	}
	*/
	// -- deletion
	
	mutating func deleteItems(_ deletedItems: [ItemIdentifierType]) {
		let dirtySections = Set(deletedItems.compactMap { sectionContaining($0) })
		dirtySections.forEach { (section) in
			guard var sectionData = sectionMetadata[section] else {
				fatalError("Expected section metadata.")
			}
			let updatedItems = sectionData.items.filter { !deletedItems.contains($0) }
			sectionData.items = updatedItems
			sectionMetadata[section] = sectionData
		}
	}
	mutating func deleteSections(_ deletedSections: [SectionIdentifierType]) {
		_sections = _sections.filter { !deletedSections.contains($0) }
		deletedSections.forEach { sectionMetadata[$0] = nil }
	}
	/*
	nonmutating func deletingItems(_ items: [ItemIdentifierType]) -> Self {
		var value = self
		// TODO:
		return value
	}
	nonmutating func deletingSections(_ sections: [SectionIdentifierType]) -> Self {
		var value = self
		// TODO:
		return value
	}
	*/
	// -- sections
	
	mutating func expandSection(_ section: SectionIdentifierType) {
		toggleSectionCollapsed(section: section, isCollapsed: false)
	}
	mutating func collapseSection(_ section: SectionIdentifierType) {
		toggleSectionCollapsed(section: section, isCollapsed: true)
	}
	private mutating func toggleSectionCollapsed(section: SectionIdentifierType, isCollapsed: Bool) {
		var sectionData = sectionMetadata[section] ?? SectionMetadata()
		sectionData.isCollapsed = isCollapsed
		sectionMetadata[section] = sectionData
	}
	/*
	nonmutating func expandingSection(_ section: SectionIdentifierType) -> Self {
		var value = self
		// TODO:
		return value
	}
	nonmutating func collapsingSection(_ section: SectionIdentifierType) -> Self {
		var value = self
		// TODO:
		return value
	}
	private nonmutating func togglingSectionCollapsed(section: SectionIdentifierType, isCollapsed: Bool) -> Self {
		var value = self
		// TODO:
		return value
	}
	*/
}

// MARK: queries
public
extension ListDataDiffableSnapshot {
	
	// MARK: - sections
	// -- headers
	func headerForSection(_ section: SectionIdentifierType) -> ItemIdentifierType? {
		sectionMetadata[section]?.header
	}
	
	func headerForItem(_ item: ItemIdentifierType) -> ItemIdentifierType? {
		guard let section = sectionContaining(item) else {
			preconditionFailure("snapshot does not contain item: \(item)")
		}
		return headerForSection(section)
	}
	
	func itemIsHeader(_ item: ItemIdentifierType) -> Bool {
		item == headerForItem(item)
	}
	
	/// Determines the section which contains the item.
	/// - Parameter item: The item whose section to determine.
	/// - Returns: The section which contains the item or nil if the snapshot does not contain the item or a section containing it.
	func sectionContaining(_ item: ItemIdentifierType) -> SectionIdentifierType? {
		for section in _sections {
			if sectionMetadata[section]?.items.contains(item) ?? false
			{ return section }
		}
		return nil
	}
	
	func itemsIn(_ section: SectionIdentifierType) -> [ItemIdentifierType] {
		guard let sectionData = sectionMetadata[section] else {
			assertionFailure("section metadata does not exist for section")
			return []
		}
		return sectionData.items
	}
	
	func isSectionCollapsed(_ section: SectionIdentifierType) -> Bool {
		guard let sectionData = sectionMetadata[section] else {
			assertionFailure("section metadata does not exist for section")
			return false
		}
		return sectionData.isCollapsed
	}
	
	// MARK: - items
	
	/// The items in the snapshot, in order respective to their corresponding section.
	func items() -> [ItemIdentifierType] {
		var items = [ItemIdentifierType]()
		_sections.forEach { (section) in
			items.append(contentsOf: sectionMetadata[section]?.items ?? [])
		}
		return items
	}

	// MARK: - indices
	
	/// Returns the index of the item within its section.
	func indexOfItem(_ item: ItemIdentifierType) -> Int {
		guard let section = sectionContaining(item) else {
			fatalError("Item does not exist in snapshot: \(item)")
		}
		guard let sectionItems = sectionMetadata[section]?.items,
			  let index = sectionItems.firstIndex(of: item) else {
			fatalError("Item is not present in the snapshot: \(item)")
		}
		return index
	}
	/// Returns the index of the section in terms of all sections in the snapshot.
	func indexOfSection(_ section: SectionIdentifierType) -> Int {
		guard let index = _sections.firstIndex(of: section) else {
			fatalError("Section is not present in the snapshot: \(section)")
		}
		return index
	}
}
