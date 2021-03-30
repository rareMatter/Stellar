//
//  SStaticListModel.swift
//  
//
//  Created by Jesse Spencer on 3/27/21.
//

import Foundation
import Combine

/// A model used to wrap static snapshots.
public
final
class SStaticListModel<SectionType, ItemType>: SListModel where SectionType: Hashable, ItemType: Hashable {
    
    public
    var snapshotSubject: CurrentValueSubject<ListDataDiffableSnapshot<SectionType, ItemType>, Never> = .init(.init())
    
    init(staticSnapshot: Snapshot) {
        self.snapshotSubject.value = staticSnapshot
    }
}
