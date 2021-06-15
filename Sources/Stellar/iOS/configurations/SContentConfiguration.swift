//
//  SContentConfiguration.swift
//  
//
//  Created by Jesse Spencer on 5/25/21.
//

import UIKit

/// An extension to `UIContentConfiguration` which provides stronger type information about the content view for use when composing content configurations.
/// This protocol also requires storage of the current cell configuration state to be used during content view updates. A default update method is provided which updates the property.
protocol SContentConfiguration: UIContentConfiguration
where Self : Equatable {
    
    func contentView() -> _SContentView<Self>
    
    /// The current configuration state. Use this property during content view updates.
    ///
    /// This property, by default protocol method, is updated after configuration state changes.
    var configurationState: UICellConfigurationState { get set }
}

extension SContentConfiguration {
    
    func makeContentView() -> UIView & UIContentView {
        contentView()
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        if let cellConfigurationState = state as? UICellConfigurationState {
            var mutated = self
            mutated.configurationState = cellConfigurationState
            return mutated
        }
        else {
            return self
        }
    }
}
