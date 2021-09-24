//
//  NLNavigationController.swift
//  Stellar
//
//  Created by Jesse Spencer on 11/6/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

public
class NLNavigationController: UINavigationController, ViewHierarchyObject {
	/// A publisher for ViewControllerDismissalNotifier conformance.
	private let _dismissalPublisher = PassthroughSubject<UIViewController, Never>()
    public var dismissalPublisher: AnyPublisher<UIViewController, Never> {
		_dismissalPublisher.eraseToAnyPublisher()
	}
	
	/// Whether the controller has been dismissed in its lifetime.
	private(set) var didDismiss = false
	
    public override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		if isDismissing || containerIsDismissing {
			didDismiss = true
			_dismissalPublisher.send(self)
		}
	}
}
