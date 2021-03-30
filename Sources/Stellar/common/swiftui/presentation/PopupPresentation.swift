//
//  PopupPresentation.swift
//  Stellar
//
//  Created by Jesse Spencer on 11/27/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

/// Modifies a view to appear as a popup with scale and opacity animation.
struct PopupModifier: ViewModifier {
	
	func body(content: Content) -> some View {
		content
			.background(Color.white)
			.cornerRadius(8)
			.padding(.vertical, 30)
			.padding(.horizontal, 12)
			.transition(AnyTransition.opacity.combined(with: .scale(scale: 0.8)).animation(.easeInOut(duration: 0.15)))
	}
}

extension View {
	/**
	Presents a popup when the given condition is true.
	- Note: This method *must* be used as a modifier to the root view or it will not present content correctly. To display several different popups, include that logic in the content closure parameter.
	- Parameter content: The content to display in the popup.
	- Parameter isPresented: A binding to whether the popup is presented.
	*/
	func popup<Content>(isPresented: Bool, onBackgroundTap: (() -> Void)? = nil , onDismiss: (() -> Void)? = nil, @ViewBuilder content: () -> Content) -> some View where Content : View {
		
		var body: some View {
			ZStack {
				if isPresented {
					Group {
						self
							.disabled(true)
						
						Rectangle()
							.fill(Color.black)
							.opacity(0.35)
							.edgesIgnoringSafeArea(.all)
						
						content().modifier(PopupModifier())
					}
				}
				else {
					self
				}
			}
		}
		return body
	}
}

struct PopupPreviewTester: View {
	@State var first = false
	@State var second = false
	
	@State var showingPopup = false
	
	var body: some View {
		VStack {
			Button("A button") {
				self.first = true
				self.showingPopup = true
			}
			
			Button("Portal") {
				self.first = true
				self.showingPopup = true
			}
		}
		.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
		.popup(isPresented: self.first) {
			if self.first {
				Rectangle().fill(Color.blue)
			}
			else {
				Rectangle().fill(Color.green)
			}
		}
	}
}

struct PopupPresentation_Previews: PreviewProvider {
    static var previews: some View {
		PopupPreviewTester()
    }
}
