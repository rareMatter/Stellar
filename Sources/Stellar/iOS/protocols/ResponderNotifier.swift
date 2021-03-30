//
//  ResponderNotifier.swift
//  Stellar
//
//  Created by Jesse Spencer on 11/11/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import Combine

/// A UIResponder object which provides publishers for events.
protocol ResponderNotifier: UIResponder {
	var didBecomeFirstResponderPublisher: AnyPublisher<UIResponder, Never> { get }
	var didResignFirstResponderPublisher: AnyPublisher<UIResponder, Never> { get }
}
