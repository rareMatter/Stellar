//
//  SEmptyContentConfiguration.swift
//  
//
//  Created by Jesse Spencer on 5/21/21.
//

import UIKit

struct SEmptyContentConfiguration: SContentConfiguration, Equatable {
    
    /// An intrinsic content size which helps to avoid layout issues when an empty content view is provided to the layout engine.
    ///
    /// This size is adjusted as needed during configuration state updates.
    private
    var intrinsicContentSize: CGSize = .init(width: 1, height: 1)
    
    var configurationState: UICellConfigurationState = .init(traitCollection: .current)
    
    func updated(for state: UIConfigurationState) -> SEmptyContentConfiguration {
        if state is UICellConfigurationState {
            var modified = self
            modified.intrinsicContentSize = .init(width: 44, height: 44)
            return modified
        }
        else {
            return self
        }
    }
}

// MARK: - content view
extension SEmptyContentConfiguration {
    
    func contentView() -> _SContentView<Self> {
        .init(configuration: self,
              intrinsicContentSizeProvider: { self.intrinsicContentSize })
    }
}

// MARK: - SContent rendering
extension SEmptyContent: UIKitContentRenderer {
    
    func mountContent(on target: UIKitRenderableContent) {
        target.contentConfiguration =
            SEmptyContentConfiguration()
    }
}
