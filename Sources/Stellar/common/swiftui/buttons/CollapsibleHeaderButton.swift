//
//  CollapsibleHeaderButton.swift
//  Stellar
//
//  Created by Jesse Spencer on 12/2/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

/// A button with a trailing arrow image which animates on tap with a toggle of the provided binding.
struct CollapsibleHeaderButton<Label: View>: View {
	
	@Binding var isCollapsed: Bool
	let onTap: () -> Void
	let label: () -> Label
	
	init(isCollapsed: Binding<Bool>, onTap: @escaping () -> Void = {}, @ViewBuilder label: @escaping () -> Label) {
		self._isCollapsed = isCollapsed
		self.onTap = onTap
		self.label = label
	}
	
	var body: some View {
		Button(action: {
			withAnimation {
				self.isCollapsed.toggle()
				self.onTap()
			}
		}) {
			self.label()
			Spacer()
			Image(systemName: "chevron.up.square")
				.imageScale(.medium)
				.rotationEffect(.degrees(isCollapsed ? 180 : 0))
		}
	}
}
