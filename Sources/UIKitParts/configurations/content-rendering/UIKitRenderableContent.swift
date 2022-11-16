//
//  UIKitRenderableContent.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

import UIKit
import utilities

@available(*, deprecated, message: "This has been replaced by the new compositional, state managed rendering system.")
/// Content that can be rendered and updated by UIKit in an efficient way.
class UIKitRenderableContent {
    
    /// The content.
    var contentConfiguration: UIContentConfiguration
    
    /// The background content.
    var backgroundConfiguration: UIBackgroundConfiguration
    
    /// Accessories which accompany the content according to their individual semantics.
    ///
    /// Most often used in lists or grids.
    var accessories: [UICellAccessory] = []
    
    /// A handler that should be called after tap interactions with the content.
    ///
    /// This can potentially be overridden if content contains higher precedence controls, such as a button.
    var tapHandler: SHashableClosure?
    
    /// Whether user interaction is disabled.
    var isDisabled: Bool
    
    /// Whether this content can be selected during editing modes.
    var isEditingSelectable: Bool
    
    required
    init(contentConfiguration: UIContentConfiguration,
         backgroundConfiguration: UIBackgroundConfiguration,
         accessories: [UICellAccessory],
         tapHandler: SHashableClosure?,
         isDisabled: Bool,
         isEditingSelectable: Bool) {
        self.contentConfiguration = contentConfiguration
        self.backgroundConfiguration = backgroundConfiguration
        self.accessories = accessories
        self.tapHandler = tapHandler
        self.isDisabled = isDisabled
        self.isEditingSelectable = isEditingSelectable
    }
    
    /// Returns an updated instance using current state.
    func updated(for configurationState: UICellConfigurationState) -> Self {
        // update configuration state using "environmental" properties
        var updatedConfigState = configurationState
        updatedConfigState.isDisabled = isDisabled
        updatedConfigState.isEditingSelectable = isEditingSelectable
        
        return .init(contentConfiguration: contentConfiguration
                        .updated(for: updatedConfigState),
                     backgroundConfiguration: backgroundConfiguration
                        .updated(for: updatedConfigState),
                     accessories: accessories,
                     tapHandler: tapHandler,
                     isDisabled: isDisabled,
                     isEditingSelectable: isEditingSelectable)
    }
    
    /// Creates a new default value instance.
    static
    func makeDefaultState() -> Self {
        .init(contentConfiguration: UIListContentConfiguration.cell(),
              backgroundConfiguration: UIBackgroundConfiguration.listPlainCell(),
              accessories: [],
              tapHandler: .init({}),
              isDisabled: false,
              isEditingSelectable: false)
    }
}
