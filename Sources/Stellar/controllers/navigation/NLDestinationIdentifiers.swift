//
//  NLDestinationIdentifiers.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 12/11/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

/// A namespace for semantic, unique identifiers for destinations within NebuList.
enum NLDestinationIdentifiers {}
// MARK: - core
extension NLDestinationIdentifiers {
	static let listMenu = "listMenu"
	static let coreUserSettingsMenu = "coreUserSettingsMenu"
}
// MARK: - lists
extension NLDestinationIdentifiers {
	static let scheduleList = "scheduleList"
	static let historyList = "historyList"
	static let unsortedList = "unsortedList"
	static let customList = "customList"
	static let labelList = "labelList"
	static let customListSectionEditor = "customListSectionEditor"
}
// MARK: - goals
extension NLDestinationIdentifiers {
	static let itemEditor = "itemEditor"
}
// MARK: - options
extension NLDestinationIdentifiers {
	static let listOptions = "listOptions"
	static let listEditingOptions = "listEditingOptions"
}
// MARK: - choosers
extension NLDestinationIdentifiers {
	static let groupChooser = "groupChooser"
	static let listChooser = "listChooser"
	static let tagChooser = "tagChooser"
	static let dateChooser = "dateChooser"
}
// MARK: - search
extension NLDestinationIdentifiers {
	static let globalSearch = "globalSearch"
}
