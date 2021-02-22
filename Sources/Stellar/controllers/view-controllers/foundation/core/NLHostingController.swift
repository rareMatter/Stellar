//
//  NLHostingController.swift
//  life-tool-1-iOS
//
//  Created by Jesse Spencer on 2/15/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import SwiftUI
import Combine

public
final class NLHostingController<RootView: View>: UIHostingController<RootView>, ViewControllerDismissalNotifier {
    /// A publisher for ViewControllerDismissalNotifier conformance.
    private let _dismissalPublisher = PassthroughSubject<UIViewController, Never>()
    public var dismissalPublisher: AnyPublisher<UIViewController, Never> {
        _dismissalPublisher.eraseToAnyPublisher()
    }
    
    /// Whether the controller has been dismissed in its lifetime.
    private(set) var didDismiss = false
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isDismissing || containerIsDismissing {
            didDismiss = true
            _dismissalPublisher.send(self)
        }
    }
}
