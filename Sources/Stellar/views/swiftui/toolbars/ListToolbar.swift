//
//  ListToolbar.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 9/14/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import SwiftUI

/// A toolbar for use with a ListState object.
public
struct ListToolbar<ItemIdentifer: Hashable>: View {

    // -- dependencies
	@ObservedObject var listState: ListState<ItemIdentifer>
	let configuration: ListToolbarConfiguration
	
    public
    init(listState: ListState<ItemIdentifer>, configuration: ListToolbarConfiguration) {
        self.listState = listState
        self.configuration = configuration
    }
    
	// -- computed helpers
	private var isEditing: Bool {
		listState.mode == .editing
	}
	private var isDisabled: Bool {
		isEditing &&
		listState.editingSelections.isEmpty
	}
	private var selectionCountText: String {
		switch listState.editingSelections.count {
			case 0:
				return "No selections"
			case 1:
				return "\(listState.editingSelections.count) selection"
			default:
				return "\(listState.editingSelections.count) selections"
		}
	}
	
	// -- views
    public var body: some View {
		if isEditing {
			VStack {
				HStack {
                    NLButton(.done {
                        self.listState.mode = .normal
                        self.configuration.doneHandler()
                    })

                    ForEach(configuration.editingButtons) { config in
						NLButton(config)
					}
					.disabled(isDisabled)
				}
				Text(selectionCountText)
			}
		}
		else {
			HStack {
				ForEach(configuration.buttons) { config in
					NLButton(config)
				}
			}
		}
	}
}
