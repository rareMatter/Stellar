//
//  ColorPickerViewController.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/28/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/// A color picker subclass which accepts closure handlers for interactions.
public
class ColorPickerViewController: UIColorPickerViewController, UIColorPickerViewControllerDelegate {
	
	/// A publisher for ViewControllerDismissalNotifier conformance.
	private let _dismissalPublisher = PassthroughSubject<UIViewController, Never>()
	
	/// Whether the controller has been dismissed in its lifetime.
	private(set) var didDismiss = false
	
	public typealias ColorSelectionHandler = (_ color: UIColor) -> Void
	public typealias OnDismissHandler = (_ viewController: ColorPickerViewController) -> Void
	
	private let onColorSelection: ColorSelectionHandler
	private let onDismiss: OnDismissHandler?
	
	// MARK: init
	public
	init(selectedColor: UIColor, onColorSelection: @escaping ColorSelectionHandler, onDismiss: OnDismissHandler? = nil, showsOpacityControl: Bool = false) {
		self.onColorSelection = onColorSelection
		self.onDismiss = onDismiss
		
		super.init()
		
		self.selectedColor = selectedColor
		supportsAlpha = showsOpacityControl
		delegate = self
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - view lifecycle
	
	public override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if isDismissing || containerIsDismissing {
			didDismiss = true
			_dismissalPublisher.send(self)
		}
	}
	
	// MARK: - delegation
	
	public func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
		onColorSelection(selectedColor)
	}
	
	public func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
		onDismiss?(self)
	}
}
extension ColorPickerViewController: ViewHierarchyObject {
    public var dismissalPublisher: AnyPublisher<UIViewController, Never> {
        _dismissalPublisher.eraseToAnyPublisher()
    }
}
