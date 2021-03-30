//
//  EditingToolbar.swift
//  Stellar
//
//  Created by Jesse Spencer on 6/5/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import SwiftUI

struct EditingToolbar: View {
	
	var items: [ToolbarItem]
	
	var body: some View {
		HStack {
			ForEach(items, id: \.id) { (toolbarItem: ToolbarItem) in
				Button(action: toolbarItem.tapHandler ?? { }) {
					Image(uiImage: toolbarItem.image)
				}
				.disabled(toolbarItem.isDisabled)
			}
		}
	}
}

struct ToolbarItem: Hashable {
	let image: UIImage
	var isDisabled: Bool = false
	var tapHandler: (() -> Void)? = nil
	
	// -- hashable
	let id = UUID()
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func == (lhs: ToolbarItem, rhs: ToolbarItem) -> Bool {
		lhs.id == rhs.id
	}
}
