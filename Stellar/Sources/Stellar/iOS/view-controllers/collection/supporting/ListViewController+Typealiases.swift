//
//  ListViewController+Typealiases.swift
//  
//
//  Created by Jesse Spencer on 4/20/21.
//

import UIKit

extension ListViewController {
    
    // data
    typealias SectionID = Model.SectionType
    typealias ItemID = Model.ItemType
    
    // collection
    typealias Snapshot = ListDataDiffableSnapshot<SectionID, ItemID>
    typealias CollectionDataSource = UICollectionViewDiffableDataSource<SectionID, ItemID>
    typealias State = ListState<ItemID>
}
