//
//  ListToolbarConfiguration.swift
//  life-tool-1-iOS
//
//  Created by Jesse Spencer on 2/12/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation

/// A configuration which can be applied to NLToolbar objects.
///
/// - Note: The editing buttons implicitly include a Done button for leaving editing mode.
public
struct ListToolbarConfiguration {
    /// Buttons which appear for normal mode.
    public var buttons: [NLButtonConfiguration]
    /// Buttons which appear for editing mode.
    public var editingButtons: [NLButtonConfiguration]
    /// This handler is called just after the list mode has been changed to normal.
    public var doneHandler: () -> Void
    
    public init(buttons: [NLButtonConfiguration] = [], editingButtons: [NLButtonConfiguration] = [], doneHandler: @escaping () -> Void = {}) {
        self.buttons = buttons
        self.editingButtons = editingButtons
        self.doneHandler = doneHandler
    }
}
