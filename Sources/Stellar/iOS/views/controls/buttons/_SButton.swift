//
//  _SButton.swift
//  
//
//  Created by Jesse Spencer on 4/27/21.
//

import UIKit

/// A button view which calls a provided handler closure when activated.
///
/// This class provides API for easily updating the button handler.
final
class _SButton: UIButton {
    
    /// The closure which is called when the primary action is activated.
    private
    var primaryActionHandler: ActionHandler = {}
    
    // -- init
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(Self.primaryAction), for: .primaryActionTriggered)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // -- action methods
    @objc
    func primaryAction() {
        primaryActionHandler()
    }
}

// MARK: - typealiases
extension _SButton {
    typealias ActionHandler = () -> Void
}

// MARK: - api
extension _SButton {
    
    /// React to button primary action activation.
    /// The primary action may be either a tap or a context menu if configured to show the menu as the primary action.
    @discardableResult
    func onPrimaryAction(_ handler: @escaping ActionHandler) -> Self {
        primaryActionHandler = handler
        return self
    }
    
}
