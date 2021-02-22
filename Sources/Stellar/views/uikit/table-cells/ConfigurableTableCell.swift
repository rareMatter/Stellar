//
//  ConfigurableTableCell.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 9/24/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// Adds a state updating method intended for cells which utilize UIConfigurationStateCustomKey in order to perform state updates on the cell's views.
///
/// Calling updateWith(_:UIConfigurationStateCustomKey, value:AnyHashable?) or the equivalent multiple state method will cause the cell to schedule a configuration update. Provide a closure by setting updateConfigurationForStateIn, in which you perform the configuration update using the provided state. Likely you will do this from a table data source cell configuration method.
@available(*, deprecated, message: "Use equivalent ConfigurableCollectionCell instead, which has been further designed and optimized to be used with ListViewController.")
class ConfigurableTableCell: UITableViewCell {
	
	typealias State = [UIConfigurationStateCustomKey : AnyHashable]
	private var data: State = .init()

	func updateWith(_ stateKey: UIConfigurationStateCustomKey, value updatedValue: AnyHashable?) {
		data[stateKey] = updatedValue
		setNeedsUpdateConfiguration()
	}
	func updateWithStates(_ updatedState: State) {
		for key in updatedState.keys {
			updateWith(key, value: updatedState[key])
		}
	}
	
	override var configurationState: UICellConfigurationState {
		var configurationState = super.configurationState
		for key in data.keys {
			configurationState[key] = data[key]
		}
		return configurationState
	}
	
	typealias ConfigurationUpdateHandler = (UICellConfigurationState, ConfigurableTableCell) -> Void
	var updateConfigurationForStateIn: ConfigurationUpdateHandler = { _, _ in
		debugPrint("cell told to update for configuration state change without handler closure set")
	}

	override func updateConfiguration(using state: UICellConfigurationState) {
		updateConfigurationForStateIn(state, self)
	}
}
