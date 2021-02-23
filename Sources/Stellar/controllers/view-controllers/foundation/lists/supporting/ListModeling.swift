//
//  ListModeling.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 8/28/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

public
protocol ListModeling: AnyObject {
	associatedtype SectionIdentifierType: Hashable
	associatedtype ItemIdentifierType: Hashable

	// -- snapshots
	typealias Snapshot = ListDataDiffableSnapshot<SectionIdentifierType, ItemIdentifierType>
	// TODO: This likely doesn't need a setter.
	var snapshot: Snapshot { get set }
	var onSnapshotDidChange: ((_ snapshot: Snapshot) -> Void)? { set get }
	
	// -- configuration
	typealias Configuration = ListConfiguration<SectionIdentifierType, ItemIdentifierType>
	var configuration: Configuration { get }
}
