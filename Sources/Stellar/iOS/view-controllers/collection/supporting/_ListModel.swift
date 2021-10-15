//
//  _ListModel.swift
//  
//
//  Created by Jesse Spencer on 9/30/21.
//

import Combine
import UIKit

extension ListViewController {
    
    /// A model object which maps a provided Data type into snapshots which are then applied to the provided collection diffable data source.
    final
    class _ListModel {

        enum SnapshotType {
            case single(Snapshot)
            case sections((snapshot: Snapshot, sectionSnapshots: [SectionType : SectionSnapshot]))
        }
        
        // The children of a row element.
        private
        let children: KeyPath<RowType, [RowType]?>?
        
        // The data source to update with snapshots as data changes.
        let collectionDataSource: CollectionDataSource
        
        private
        var cancellables: Set<AnyCancellable> = .init()
        
        init(sectionSubject: CurrentValueSubject<[SectionType], Never>,
             children: KeyPath<RowType, [RowType]?>?,
             collectionDataSource: CollectionDataSource) {
            self.children = children
            self.collectionDataSource = collectionDataSource
            
            // Connect data subject to snapshot subject via mapping.
            sectionSubject
                .receive(on: DispatchQueue.main)
                .map { listSections -> (SnapshotType, [ListSection]) in
                    (Self.makeSnapshot(from: listSections,
                                       children: children),
                     listSections)
                }
                .sink { [unowned self] (snapshotType, listSections) in
                    // update snapshot
                    updateSnapshot(with: snapshotType)
                    
                    // update section subscriptions
                    listSections
                        .forEach { [unowned self] listSection in
                            listSection.dataSubject
                                .map { sectionRows -> NSDiffableDataSourceSectionSnapshot<RowType> in
                                    var snapshot = NSDiffableDataSourceSectionSnapshot<RowType>()
                                    Self.populateSectionSnapshot(&snapshot,
                                                                 rows: sectionRows,
                                                                 childrenKeypath: children)
                                    return snapshot
                                }
                                .sink { sectionSnapshot in
                                    collectionDataSource.apply(sectionSnapshot,
                                                               to: listSection,
                                                               animatingDifferences: true)
                                }
                                .store(in: &cancellables)
                        }
                }
                .store(in: &cancellables)
            
            // Create initial snapshot, before subscriptions are received.
            updateSnapshot(with: Self.makeSnapshot(from: sectionSubject.value,
                                                   children: children))
        }
        
        // MARK: Snapshot creation
        
        /// Updates the collection data source with a new snapshot.
        private
        func updateSnapshot(with snapshotType: SnapshotType) {
            
            switch snapshotType {
                case let .single(snapshot):
                    collectionDataSource.apply(snapshot)
                
                case let .sections((snapshot, sections)):
                    collectionDataSource.apply(snapshot)
                    sections.forEach { (section, sectionSnapshot) in
                        collectionDataSource.apply(sectionSnapshot,
                                                   to: section,
                                                   animatingDifferences: true)
                    }
            }
        }
        
        private
        static
        func makeSnapshot(from sections: [ListSection],
                          children: KeyPath<RowType, [RowType]?>?) -> SnapshotType {
            
            func makeLinearSnapshot(from sections: [ListSection]) -> SnapshotType {
                // Create snapshot and append sections
                var snapshot = Snapshot()
                snapshot.appendSections(sections)
                
                // Append items to respective sections
                snapshot.sectionIdentifiers.forEach { section in
                    snapshot.appendItems(section.dataSubject.value,
                                         toSection: section)
                }
                
                return .single(snapshot)
            }
            func makeHierarchicalSnapshot(from sections: [ListSection],
                                          childrenKeypath: KeyPath<RowType, [RowType]?>) -> SnapshotType {
                var snapshot = Snapshot()
                snapshot.appendSections(sections)
                // Use section snapshots for hierarchical support. They must be applied to an existing section.
                var sectionSnapshots = [SectionType : NSDiffableDataSourceSectionSnapshot<RowType>]()
                // populate each section.
                sections.forEach { section in
                    var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<RowType>()
                    populateSectionSnapshot(&sectionSnapshot,
                                            rows: section.dataSubject.value,
                                            childrenKeypath: childrenKeypath)
                    sectionSnapshots[section] = sectionSnapshot
                }
                
                return .sections((snapshot, sectionSnapshots))
            }
            
            if let children = children {
                return makeHierarchicalSnapshot(from: sections,
                                                childrenKeypath: children)
            }
            else {
                return makeLinearSnapshot(from: sections)
            }
        }
        
        /// Recursively populates the section snapshot using the provided data and a keypath to any children it may have.
        private
        static
        func populateSectionSnapshot(_ sectionSnapshot: inout NSDiffableDataSourceSectionSnapshot<RowType>,
                                     rows: [RowType],
                                     childrenKeypath: KeyPath<RowType, [RowType]?>?) {
            // Populates a non-hierarchical section snapshot.
            func populateRegularSectionSnapshot(_ sectionSnapshot: inout NSDiffableDataSourceSectionSnapshot<RowType>,
                                                rows: [RowType]) {
                sectionSnapshot.append(rows,
                                       to: nil)
            }
            // Populates a hierarchical section snapshot.
            func populateHierarchicalSectionSnapshot(_ sectionSnapshot: inout NSDiffableDataSourceSectionSnapshot<RowType>,
                                                     withParent parent: RowType?,
                                                     children: [RowType]?,
                                                     childrenKeypath: KeyPath<RowType, [RowType]?>) {
                sectionSnapshot.append(children ?? [],
                                       to: parent)
                
                // Recurse with children
                children?.forEach({ child in
                    populateHierarchicalSectionSnapshot(&sectionSnapshot,
                                                        withParent: child,
                                                        children: child[keyPath: childrenKeypath],
                                                        childrenKeypath: childrenKeypath)
                })
            }
            
            if let childrenKeypath = childrenKeypath {
                populateHierarchicalSectionSnapshot(&sectionSnapshot,
                                                    withParent: nil,
                                                    children: rows,
                                                    childrenKeypath: childrenKeypath)
            }
            else {
                populateRegularSectionSnapshot(&sectionSnapshot,
                                               rows: rows)
            }
        }
        
        // MARK: API
        
        /// The current snapshot applied to the collection data source.
        var snapshot: Snapshot {
            collectionDataSource.snapshot()
        }
        
        /// If nil, the data source snapshot will be reapplied.
        func applyTemporarySnapshot(_ snapshot: Snapshot?) {
            if let tempSnap = snapshot {
                collectionDataSource.apply(tempSnap)
            }
            else {
                collectionDataSource.apply(self.snapshot)
            }
        }
    }
}
