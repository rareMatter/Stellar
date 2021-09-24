//
//  ListDataDiffableSnapshot+Conversion.swift
//  
//
//  Created by Jesse Spencer on 4/20/21.
//

import UIKit

extension ListDataDiffableSnapshot {
    
    /** Bridges the receiver to an NSDiffableDataSourceSnapshot.
     
     - Warning: Not all data contained by this type can be represented in the returned snapshot. Specifically, collapsed state of Sections is translated as Items being excluded from the Section entirely, with the exception of an Item that is the Section header.
     */
    func makeNSSnapshot() -> NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType> {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        snapshot.appendSections(self.sections)
        
        // create sections and items
        for section in self.sections {
            let itemsInSection = itemsIn(section)
            if isSectionCollapsed(section) {
                let items = itemsInSection.filter { (item) -> Bool in
                    if let headerItemInSection = headerForSection(section) {
                        return item == headerItemInSection
                    }
                    else { return false }
                }
                snapshot.appendItems(items, toSection: section)
            }
            else {
                snapshot.appendItems(itemsInSection, toSection: section)
            }
        }
        
        // bridge transferable metadata
        for (section, data) in sectionMetadata {
            if data.needsReloading {
                snapshot.reloadSections([section])
            }
        }
        for (item, data) in itemMetadata {
            if data.needsReloading {
                snapshot.reloadItems([item])
            }
        }
        
        return snapshot
    }
}
