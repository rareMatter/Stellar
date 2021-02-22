//
//  NLViewController.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 11/6/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

open
class NLViewController: UIViewController {
	
	/// Whether the view has appeared in the controller's lifetime.
	private(set) var viewHasAppeared = false
	
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewHasAppeared = true
	}
	
	/// A publisher for ViewControllerDismissalNotifier conformance.
	private let _dismissalPublisher = PassthroughSubject<UIViewController, Never>()
	
	/// Whether the controller has been dismissed in its lifetime.
	private(set) var didDismiss = false
	
	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if isDismissing || containerIsDismissing {
			didDismiss = true
			_dismissalPublisher.send(self)
		}
	}
}
extension NLViewController: ViewControllerDismissalNotifier {
	
	public var dismissalPublisher: AnyPublisher<UIViewController, Never> {
		_dismissalPublisher.eraseToAnyPublisher()
	}
}
