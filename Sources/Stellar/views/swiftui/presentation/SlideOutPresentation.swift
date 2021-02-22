//
//  SlideOutPresentation.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 11/28/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

/// Modifies a view to appear as a slide-out with scale animation.
struct SlideOutModifier: ViewModifier {
	
	func body(content: Content) -> some View {
		content
			.background(Color.white)
			.cornerRadius(8)
			.padding(.vertical, 30)
			.padding(.horizontal, 12)
			.transition(AnyTransition.opacity.combined(with: .scale).animation(.easeInOut(duration: 0.3)))
	}
}

extension View {
	/**
	Presents a slide-out originating at the modified view when the given condition is true.
	- Parameter content: The content to display.
	- Parameter isPresented: A binding to whether the content is presented.
	*/
	func slideOut<Content>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: () -> Content) -> some View where Content : View {
		
		var body: some View {
			Group {
				if isPresented.wrappedValue {
					content()
						.modifier(SlideOutModifier())
				}
				else {
					self
				}
			}
			.onTapGesture {
				isPresented.wrappedValue = false
			}
		}
		
		return body
	}
}

struct SlideOutPreviewTester: View {
	@State var first = false
	@State var second = false
	
	var body: some View {
		VStack {
			Button("A button") {
				self.first = true
			}
			.slideOut(isPresented: self.$first) {
				Rectangle()
			}
			
			Button("Portal") {
				self.second = true
			}
			.slideOut(isPresented: self.$second) {
				Rectangle()
			}
		}
	}
}

struct SlideOutPresentation_Previews: PreviewProvider {
	static var previews: some View {
		SlideOutPreviewTester()
	}
}
