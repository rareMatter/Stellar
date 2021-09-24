//
//  TextViewRepresentable.swift
//  Stellar
//
//  Created by Jesse Spencer on 12/2/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import SwiftUI

struct TextViewRepresentable: UIViewRepresentable {
	
	// -- Static Properties
	// TODO: This guess could be possibly be replaced using UITextView instance methods. +2 because it still doesn't quite fit???
	static var emptyHeight: CGFloat { TextViewRepresentable.fontDefault.lineHeight + TextViewRepresentable.textContainerInsetsDefault.top + TextViewRepresentable.textContainerInsetsDefault.bottom + 2 }
	
	/// The default system font used by this text view.
	static var fontDefault: UIFont { UIFont.preferredFont(forTextStyle: .body) }
	
	// This should be default but is used here for brevity.
	static let textContainerInsetsDefault: UIEdgeInsets = .init(top: 8, left: 0, bottom: 8, right: 0)
	// --
	
	// -- Instance Properties
	/// The text in the text view.
	@Binding var text: String
	var placeholderText: String
	/// A constant width used to determine height.
	let width: CGFloat
	/// A callback which should be used for sizing the frame of the text view.
	let didChangeHeight: (_ : CGFloat) -> Void
	// --
	
	func makeUIView(context: Context) -> KMPlaceholderTextView {
		let view = KMPlaceholderTextView()
		
		view.delegate = context.coordinator
		view.textContainer.maximumNumberOfLines = 0
		view.textContainer.lineBreakMode = .byWordWrapping
		view.font = TextViewRepresentable.fontDefault
		view.textContainerInset = TextViewRepresentable.textContainerInsetsDefault
		view.placeholder = placeholderText
		
		// Init with text.
		view.text = self.text
		
		// Make init sizing callback.
		if self.text.isEmpty {
			// Size for empty.
			let size = view.sizeThatFits(CGSize(width: self.width, height: TextViewRepresentable.emptyHeight))
			view.frame.size = size
			didChangeHeight(size.height)
		}
		else {
			// Size to text.
			let size = view.sizeThatFits(CGSize(width: self.width, height: .infinity))
			view.frame.size = size
			didChangeHeight(size.height)
		}
		
		return view
	}
	
	func updateUIView(_ uiView: KMPlaceholderTextView, context: Context) {
		uiView.text = text
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, UITextViewDelegate {
		
		let parent: TextViewRepresentable
		
		init(_ parent: TextViewRepresentable) {
			self.parent = parent
		}
		
		// -- Delegation
		func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
			return true
		}
		
		func textViewDidChange(_ textView: UITextView) {
			// Update text.
			self.parent.text = textView.text
			
			// Make size change callback.
			textView.frame.size = CGSize(width: parent.width, height: textView.contentSize.height)
			let newSize = textView.frame.size
			parent.didChangeHeight(newSize.height)
		}
		// --
	}
}
