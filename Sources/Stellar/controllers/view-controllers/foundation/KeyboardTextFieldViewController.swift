//
//  KeyboardTextFieldViewController.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 6/5/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import SnapKit

public
class KeyboardTextFieldViewController: NLViewController, UITextFieldDelegate {
	
	// views
	private var visualEffectView: UIVisualEffectView!
	private var vibrancyEffectView: UIVisualEffectView!
	private var cancelLabel: UILabel!
	
	private var hStack: UIStackView!
	private var textField = UITextField()
	
	private var toolbarYConstraint: Constraint!
	
	// subscriptions
	private var keyboardWillChangeFrame: AnyCancellable?
	private var keyboardWillHide: AnyCancellable?
	
	// callbacks
	public typealias CallbackHandler = (KeyboardTextFieldViewController) -> Void
	public var onCancel: CallbackHandler?
	public var onConfirm: CallbackHandler?
	
	// MARK: - init
	
    public override func viewDidLoad() {
		super.viewDidLoad()
		configureHierarchy()
		initKeyboardSubscriptions()
	}
	
	private func configureHierarchy() {
		view.backgroundColor = nil
		
		// blur background
		let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
		visualEffectView = UIVisualEffectView(effect: blurEffect)
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(sender:))))
		view.addSubview(visualEffectView)
		
		let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .secondaryLabel)
		vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
		vibrancyEffectView.translatesAutoresizingMaskIntoConstraints = false
		visualEffectView.contentView.addSubview(vibrancyEffectView)
		
		// cancel indicator label
		cancelLabel = UILabel()
		cancelLabel.text = NSLocalizedString("Tap anywhere to cancel", comment: "")
		cancelLabel.adjustsFontForContentSizeCategory = true
		cancelLabel.font = UIFont.preferredFont(forTextStyle: .body)
		cancelLabel.textColor = .secondaryLabel
		vibrancyEffectView.contentView.addSubview(cancelLabel)
		
		// text field
		textField.font = UIFont.preferredFont(forTextStyle: .title1)
		textField.textColor = .label
		textField.borderStyle = .none
		textField.returnKeyType = .done
		textField.delegate = self
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		// buttons
		let symbolConfig = UIImage.SymbolConfiguration(textStyle: .title1)
		
		let acceptButton = UIButton()
		acceptButton.accessibilityLabel = "accept"
		acceptButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
		acceptButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
		acceptButton.addTarget(self, action: #selector(self.doneTapped), for: .touchUpInside)
		
		// hstack
		hStack = UIStackView(arrangedSubviews: [
			textField,
			acceptButton
		])
		hStack.axis = .horizontal
		hStack.distribution = .fill
		hStack.alignment = .fill
		hStack.translatesAutoresizingMaskIntoConstraints = false
		hStack.isLayoutMarginsRelativeArrangement = true
		hStack.spacing = 8.0
		hStack.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
		hStack.alpha = 0
		
		textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
		acceptButton.setContentHuggingPriority(.required, for: .horizontal)
		
		textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		acceptButton.setContentCompressionResistancePriority(.required, for: .horizontal)
		
		view.addSubview(hStack)
	}
	
	private func initKeyboardSubscriptions() {
		keyboardWillChangeFrame = NotificationCenter.default
			.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
			.receive(on: RunLoop.main)
			.sink(receiveValue: { self.willChangeKeyboardFrame(notification: $0) })
		keyboardWillHide = NotificationCenter.default
			.publisher(for: UIResponder.keyboardWillHideNotification)
			.receive(on: RunLoop.main)
			.sink(receiveValue: { self.willHideKeyboard(notification: $0) })
	}
	
	// MARK: - view lifecycle
	
	private var needsConstraintsSetup = true
	
    public override func updateViewConstraints() {

		if needsConstraintsSetup {
			visualEffectView.snp.makeConstraints { (make) in
				make.edges.equalToSuperview()
			}
			
			vibrancyEffectView.snp.makeConstraints { (make) in
				make.edges.equalToSuperview()
			}
			
			cancelLabel.snp.makeConstraints { (make) in
				make.leading.equalTo(view.snp.leadingMargin)
				make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			}
			
			hStack.snp.makeConstraints { (make) in
				make.leading.equalTo(hStack.superview!.safeAreaLayoutGuide.snp.leading)
				make.trailing.equalTo(hStack.superview!.safeAreaLayoutGuide.snp.trailing)
				self.toolbarYConstraint = make.bottom.equalTo(hStack.superview!.snp.bottomMargin).constraint
			}
			
			needsConstraintsSetup = false
		}
		
		super.updateViewConstraints()
	}
	
    public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		textField.becomeFirstResponder()
		if !textField.isFirstResponder { hStack.alpha = 1 }
	}
	
	// MARK: - keyboard methods
	
	/// Updates the toolbar position for keyboard changes.
	private func willChangeKeyboardFrame(notification: Notification) {
		updateForKeyboard(notification: notification, isHiding: false)
	}
	private func willHideKeyboard(notification: Notification) {
		updateForKeyboard(notification: notification, isHiding: true)
	}
	
	private var updatingForKeyboard = false
	private func updateForKeyboard(notification: Notification, isHiding: Bool) {
		guard let userInfo = notification.userInfo else { fatalError("Expected userInfo object") }
		// Determine frame of keyboard
		guard let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { fatalError("Expected end frame object") }
		// parse animation parameters
		guard
			let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
			let animationCurveNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
			let animationCurve = UIView.AnimationCurve(rawValue: animationCurveNSN.intValue)
			else { fatalError("Could not parse animation parameters") }
		
		let animator = UIViewPropertyAnimator(duration: duration, curve: animationCurve) { [weak self] in
			guard let self = self else { return }
			
			self.view.layoutMargins.bottom = isHiding ? 0 : ((self.view.bounds.maxY - endFrame.minY) - self.view.safeAreaInsets.bottom)
			self.hStack.alpha = isHiding ? 0 : 1
			self.view.layoutIfNeeded()
		}
		animator.startAnimation()
	}
	
	// MARK: - action methods
	
	@objc
	private func doneTapped() {
		onConfirm?(self)
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc
	private func backgroundTapped(sender: UITapGestureRecognizer) {
		if sender.state == .ended {
			onCancel?(self)
			dismiss(animated: true, completion: nil)
		}
	}
	
	// MARK: - text field delegate
	
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		onConfirm?(self)
		dismiss(animated: true, completion: nil)
		return true
	}
}
// MARK: - api
public
extension KeyboardTextFieldViewController {
	
	var text: String? {
		get { textField.text }
		set { textField.text = newValue }
	}
	
	var placeholderText: String? {
		get { textField.placeholder }
		set { textField.placeholder = newValue }
	}
	
}

#if DEBUG

struct KeyboardTextFieldViewControllerRepresentable: UIViewRepresentable {
	
	func makeUIView(context: Context) -> UIView {
		return KeyboardTextFieldViewController(nibName: nil, bundle: nil).view
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {}
}

struct KeyboardTextFieldViewController_Preview: PreviewProvider {
	
	static var previews: some View {
		Group {
			KeyboardTextFieldViewControllerRepresentable()
				.background(Color(UIColor.secondarySystemBackground))
			KeyboardTextFieldViewControllerRepresentable()
				.background(Color(UIColor.secondarySystemBackground))
				.environment(\.colorScheme, .dark)
		}
	}
}
#endif
