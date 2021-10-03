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
            case sections((snapshot: Snapshot, sectionSnapshots: [SectionType : NSDiffableDataSourceSectionSnapshot<Data.Element>]))
        }
        typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, Data.Element>
        
        /// The data to map into section snapshots, depending on its stucture.
        let dataSubject: CurrentValueSubject<Data, Never>
        let children: KeyPath<Data.Element, Data?>?
        
        let collectionDataSource: UICollectionViewDiffableDataSource<SectionType, Data.Element>
        
        var snapshot: Snapshot {
            collectionDataSource.snapshot()
        }
        
        private
        var cancellables: Set<AnyCancellable> = .init()
        
        init(dataSubject: CurrentValueSubject<Data, Never>,
             children: KeyPath<Data.Element, Data?>?,
             collectionDataSource: UICollectionViewDiffableDataSource<SectionType, Data.Element>) {
            self.dataSubject = dataSubject
            self.children = children
            self.collectionDataSource = collectionDataSource
            
            // TODO: connect data subject to snapshot subject via mapping.
            dataSubject
                .receive(on: DispatchQueue.main)
                .map { data -> SnapshotType in
                    if let children = children {
                        return Self.makeHierarchicalSnapshot(from: data,
                                                             childrenKeypath: children,
                                                             withDataSource: collectionDataSource)
                    }
                    else {
                        return Self.makeSnapshot(from: data,
                                          children: children)
                    }
                }
                .sink { snapshotType in
                    switch snapshotType {
                        case let .single(snapshot):
                            collectionDataSource.apply(snapshot)
                        case let .sections((snapshot, sections)):
                            collectionDataSource.apply(snapshot)
                            sections.forEach { (section, sectionSnapshot) in
                                collectionDataSource.apply(sectionSnapshot,
                                                           to: section)
                            }
                    }
                }
                .store(in: &cancellables)
        }
        
        /// If nil, the data source snapshot will be applied.
        func applyTemporarySnapshot(_ snapshot: Snapshot?) {
            if let tempSnap = snapshot {
                collectionDataSource.apply(tempSnap)
            }
            else {
                collectionDataSource.apply(self.snapshot)
            }
        }
        
        private
        static
        func makeSnapshot(from data: Data,
                          children: KeyPath<Data.Element, Data?>?) -> SnapshotType {
            
            var snapshot = populateSnapshotWithSections(.init(), data: data)
            
            /* A single section is being used until SContent sections are implemented.
            // populate sections with data
            snapshot.sectionIdentifiers.forEach { identifiableSection in
                snapshot.appendItems(Array(identifiableSection.section.contents),
                                     toSection: identifiableSection)
            }
             */
            snapshot.sectionIdentifiers.forEach { section in
                snapshot.appendItems(Array(data),
                                     toSection: section)
            }
            
            return .single(snapshot)
        }
        
        private
        static
        func makeHierarchicalSnapshot(from data: Data,
                                      childrenKeypath: KeyPath<Data.Element, Data?>,
                                      withDataSource collectionDataSource: UICollectionViewDiffableDataSource<SectionType, Data.Element>) -> SnapshotType {
            
            /// Recursively populates the section snapshot using the provided data and a keypath to any children it may have.
            func populateSectionSnapshot(_ sectionSnapshot: inout NSDiffableDataSourceSectionSnapshot<Data.Element>,
                                         withParent parent: Data.Element,
                                         childrenKeypath: KeyPath<Data.Element, Data?>) {
                
                // Recursively populate the snapshot using the hierarchical data.
                if let children = parent[keyPath: childrenKeypath] {
                    sectionSnapshot.append(Array(children), to: parent)
                    
                    // recurse with each child
                    children.forEach { child in
                        populateSectionSnapshot(&sectionSnapshot,
                                                withParent: child,
                                                childrenKeypath: childrenKeypath)
                    }
                }
            }
            
            let snapshot = populateSnapshotWithSections(.init(), data: data)
            var sections = [SectionType : NSDiffableDataSourceSectionSnapshot<Data.Element>]()
            
            snapshot.sectionIdentifiers.forEach { section in
                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Data.Element>()
                
                let sectionContents = snapshot.itemIdentifiers(inSection: section)
                sectionContents
                    .forEach { item in
                        populateSectionSnapshot(&sectionSnapshot,
                                                withParent: item,
                                                childrenKeypath: childrenKeypath)
                    }
                
                sections[section] = sectionSnapshot
            }
            
            return .sections((snapshot, sections))
        }
        
        /// Returns a snapshot which has been populated with one or many `SIdentifiableSections` based on the data provided.
        private
        static
        func populateSnapshotWithSections(_ snapshot: NSDiffableDataSourceSnapshot<SectionType, Data.Element>,
                                          data: Data) -> NSDiffableDataSourceSnapshot<SectionType, Data.Element> {
            var snapshot = snapshot
            
            /* A single section is being used until SContent sections are implemented.
            if Data.Element.self is SSection<Data>.Type {
                // map user-provided sections into identifiable sections.
                var index = 0
                snapshot.appendSections(data.compactMap { $0 as? SSection<Data> }
                                            .map { section in
                    let section = SIdentifiableSection(id: index,
                                                       section: section)
                    index += 1
                    return section
                })
            }
            else {
                // create a single identifiable section.
                snapshot.appendSections([.init(id: 0, section: .init(contents: data))])
            }
             */
            
            snapshot.appendSections([0])
            
            return snapshot
        }
    }
}
