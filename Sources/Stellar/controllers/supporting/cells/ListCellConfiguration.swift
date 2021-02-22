//
//  ListCellConfiguration.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 8/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "Use modern cell configuration instead.")
struct CellConfigurationState {
	var isEditing: Bool
	var isSwiped: Bool
	var isCollapsed: Bool
}
@available(*, deprecated, message: "Use modern cell configuration instead.")
protocol ListCellUpdating {
	func updateForState(_ configurationState: CellConfigurationState)
}

/** A registration for a cell type.
Use this type to configure cells which will appear in the list.
*/
@available(*, deprecated, message: "Use UICollectionView registrations instead.")
struct ListCellConfigurator<Cell, ViewModel, RowIdentifierType> where Cell : UITableViewCell, RowIdentifierType : Hashable {
	/// A closure which handles cell configuration.
	typealias ConfigurationHandler = (Cell, ViewModel, ListState<RowIdentifierType>, IndexPath) -> Void
	
	let configurationHandler: ConfigurationHandler
	
	init(configurationHandler: @escaping ConfigurationHandler) {
		self.configurationHandler = configurationHandler
	}
}
