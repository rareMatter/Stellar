//
//  ListState.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/12/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import Foundation

/// A sharable state management object for lists.
///
/// This object stores and publishes a list's mode and selections for `ListMode.editing`.
public
final class ListState<ItemIdentifier: Hashable>: ObservableObject {
    @Published public var mode: ListMode
	@Published public var editingSelections: Set<ItemIdentifier>
	
    public
	init(mode: ListMode = .normal, editingSelections: Set<ItemIdentifier> = .init()) {
		self.mode = mode
		self.editingSelections = editingSelections
	}
}
