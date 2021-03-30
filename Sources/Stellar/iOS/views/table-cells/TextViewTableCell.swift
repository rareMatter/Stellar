//
//  TextViewTableCell.swift
//  Stellar
//
//  Created by Jesse Spencer on 4/10/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

@available(*, deprecated, message: "Use ConfigurableCollectionCell with an appropriate content configuration instead.")
public
class TextViewTableCell: UITableViewCell {
	
    public 
	class var reuseID: String { "TextViewCell" }
	
    public var textView: KMPlaceholderTextView!
	
	// -- Callbacks
	public var onEnteredNewline: ((_ textView: UITextView) -> Bool)?
    public var onTextDidChange: ((_ textView: UITextView) -> Void)?
    public var onSelectionDidChange: ((_ textView: UITextView) -> Void)?
    public var onEndEditing: ((_ textView: UITextView) -> Void)?
	// --
	
	// MARK: Init
    public
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureHierarchy()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configureHierarchy() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = UIColor.systemBackground
		
		textView = KMPlaceholderTextView(frame: .zero)
		
		textView.placeholder = "A placeholder..."
		
		// Font
		textView.adjustsFontForContentSizeCategory = true
		textView.textAlignment = .natural
		textView.placeholderColor = UIColor.placeholderText
		textView.font = .preferredFont(forTextStyle: .title1)
		textView.textColor = .label
		textView.isScrollEnabled = false
		textView.delegate = self
		
		contentView.addSubview(textView)
		textView.snp.remakeConstraints { (make) in
			make.top.equalTo(contentView.snp.topMargin)
			make.bottom.equalTo(contentView.snp.bottomMargin)
			make.trailing.equalTo(contentView.snp.trailingMargin)
			make.leading.equalTo(contentView.snp.leadingMargin)
		}
	}
	
	// MARK: First Responder Properties and Overrides

	/// A callback for when the text view has become the first responder.
    public var onDidBecomeFirstResponder: (() -> Void) = { assertionFailure("Did not set callback for first responder state.")}
	/// A callback for when the text view has resigned first responder.
    public var onDidResignFirstResponder: (() -> Void) = { assertionFailure("Did not set callback for first responder state.")}
	
	/// Whether the receiver's text view is first responder.
    public override var isFirstResponder: Bool {
		// Tie first responder status of the cell to the text view.
		textView.isFirstResponder
	}
	
	/// Passes first responder status onto the contained text view.
    public override func becomeFirstResponder() -> Bool {
		super.becomeFirstResponder()
		return textView.becomeFirstResponder()
	}
	
	/// Passes first responder status onto the contained text view.
    public override func resignFirstResponder() -> Bool {
		super.resignFirstResponder()
		return textView.resignFirstResponder()
	}
}
// MARK: Text View Delegate
extension TextViewTableCell: UITextViewDelegate {
	
    public func textViewDidBeginEditing(_ textView: UITextView) {
		onDidBecomeFirstResponder()
	}
	
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		// Check that string is a single character and valid (allows pastes which contain newlines).
		if ((text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location != NSNotFound) && text.count == 1 {
			return onEnteredNewline?(textView) ?? true
		}
		else {
			return true
		}
	}
	
    public func textViewDidChange(_ textView: UITextView) {
		onTextDidChange?(textView)
	}
	
    public func textViewDidChangeSelection(_ textView: UITextView) {
		onSelectionDidChange?(textView)
	}
	
    public func textViewDidEndEditing(_ textView: UITextView) {
		onEndEditing?(textView)
		onDidResignFirstResponder()
	}
}
// MARK: API Properties
public 
extension TextViewTableCell {
	
	func setFont(_ font: UIFont) {
		textView.font = font
	}
	
	func setText(_ text: String) {
		textView.text = text
	}
	
	/// A convenience computed property for the property of the text view.
	func setPlaceholderText(_ text: String) {
		textView.placeholder = text
	}
	
}

// MARK: - Live Preview support
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct TextViewTableCellRepresentable: UIViewRepresentable {
	func makeUIView(context: Context) -> UIView {
		let view = TextViewTableCell(style: .default, reuseIdentifier: TextViewTableCell.reuseID)
		view.textView.text = "AhHhHHHhhhhhjkl"
		return view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {
	}
}

@available(iOS 13.0, *)
struct TextViewTableCell_Preview: PreviewProvider {
	static var previews: some View {
		return
			Group {
				TextViewTableCellRepresentable()
					.previewLayout(.fixed(width: 350, height: 50))
				TextViewTableCellRepresentable()
					.previewLayout(.fixed(width: 350, height: 50))
					.environment(\.colorScheme, .dark)
		}
	}
}
#endif

