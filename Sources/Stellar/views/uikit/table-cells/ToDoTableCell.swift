//
//  ToDoTableCell.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 9/18/19.
//  Copyright © 2019 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

@available(*, deprecated, message: "Use ConfigurableCollectionCell with an appropriate content configuration instead.")
public
class ToDoTableCell: TextViewTableCell {
	
    public
	class override var reuseID: String { "ToDo" }
	
    public
	enum CompletionButtonStyle: String {
		case complete = "circle.fill"
		case incomplete = "circle"
		case canceled = "x.circle.fill"
	}
	
	// Views
    public var completionButton: UIButton!
	
	// Completion button images
	let completeButtonImage = UIImage(systemName: "circle.fill")
	let incompleteButtonImage = UIImage(systemName: "circle")
	let canceledImage = UIImage(systemName: "x.circle.fill")
	
	// Long Press Gesture
	private var longPressGesture: UILongPressGestureRecognizer!
	
	// -- Callbacks
	/// A callback for when the completion button has been tapped.
	/// The return value specifies whether the button should transition to the returned state.
    public var onToggleComplete: (() -> Bool) = {
		assertionFailure("Callback not set.")
		return false
	}
	
	/// A callback for when the completion button has received a long press gesture.
    public var onLongPressComplete: (() -> Bool) = {
		assertionFailure("Callback not set.")
		return false
	}
	// --
	
	// MARK: Init
    public
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		configureHierarchy()
	}
	
	private func configureHierarchy() {
		completionButton = UIButton(type: .custom)
		completionButton.translatesAutoresizingMaskIntoConstraints = false
		updateCompletionButton(for: .incomplete)
		completionButton.addTarget(self, action: #selector(Self.complete(_:)), for: .touchUpInside)
		contentView.addSubview(completionButton)
		
		// Long press gesture to cancel.
		longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGesture(_:)))
		longPressGesture.minimumPressDuration = 0.3
		self.completionButton.addGestureRecognizer(longPressGesture)
		
		textView.snp.remakeConstraints { make in
			make.top.equalTo(contentView.snp.topMargin)
			make.bottom.equalTo(contentView.snp.bottomMargin)
			make.trailing.equalTo(contentView.snp.trailingMargin)
		}
		completionButton.snp.remakeConstraints { (make) in
			make.leading.equalTo(contentView.snp.leadingMargin)
			make.trailing.equalTo(textView.snp.leading)
//			make.firstBaseline.equalTo(textView.snp.firstBaseline)
			make.centerY.equalTo(contentView)
			make.size.equalTo(35)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Action Methods
	
	@objc private
	func complete(_ sender: Any) {
		let complete = onToggleComplete()
		updateCompletionButton(for: complete ? .complete : .incomplete)
	}
	
	@objc private
	func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
		if gesture.state == .began {
			if onLongPressComplete() { updateCompletionButton(for: .canceled) }
			let feedback = UINotificationFeedbackGenerator()
			feedback.notificationOccurred(.warning)
		}
	}
	
	// MARK: - View Updating
	
	/// Updates the completion button image using current Item state.
    public func updateCompletionButton(for completionState: CompletionButtonStyle) {
		completionButton.setImage(UIImage(systemName: completionState.rawValue), for: .normal)
	}
}
// MARK: API
public
extension ToDoTableCell {
	
	func setButtonImageStyle(configuration: UIImage.SymbolConfiguration?) {
		completionButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
	
	}
}

// MARK: - Live Preview support
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ToDoTableCellViewRepresentable: UIViewRepresentable {
	
	var text: String?
	var placeholder: String?
	
	func makeUIView(context: Context) -> ToDoTableCell {
		let view = ToDoTableCell(style: .default, reuseIdentifier: ToDoTableCell.reuseID)
		return view
	}
	
	func updateUIView(_ uiView: ToDoTableCell, context: Context) {
//		uiView.setText(text ?? "")
		uiView.setPlaceholderText(placeholder ?? "")
	}
}

@available(iOS 13.0, *)
struct ToDoTableCell_Preview: PreviewProvider {
	static var previews: some View {
		let placeholder = ToDoTableCellViewRepresentable(text: nil, placeholder: "A To-Do...")
		
		return
			Group {
				placeholder
				ToDoTableCellViewRepresentable()
				ToDoTableCellViewRepresentable()
					.environment(\.colorScheme, .dark)
		}
		.previewLayout(.fixed(width: 350, height: 50))
	}
}
#endif

