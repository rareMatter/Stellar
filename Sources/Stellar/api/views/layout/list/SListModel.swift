//
//  SListModel.swift
//  
//
//  Created by Jesse Spencer on 3/2/21.
//

import Combine

/// Describes a model which is used by SListView to provide data updates to the list.
public
protocol SListModel: AnyObject {
    associatedtype SectionType: Hashable
    associatedtype ItemType: Hashable
    typealias Snapshot = ListDataDiffableSnapshot<SectionType, ItemType>
    
    /// The current subject used by the list. When this subject changes the list will update.
    var snapshotSubject: CurrentValueSubject<Snapshot, Never> { get }
}
public
extension SListModel {
    /// A convenience accessor to the snapshot contained by `snapshotSubject`.
    var snapshot: Snapshot {
        get { snapshotSubject.value }
        set { snapshotSubject.value = newValue }
    }
}
