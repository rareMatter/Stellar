//
//  SContentConfiguration.swift
//  
//
//  Created by Jesse Spencer on 5/25/21.
//

import UIKit

/// An extension to `UIContentConfiguration` which provides stronger type information about the content view for use when composing content configurations.
protocol SContentConfiguration: UIContentConfiguration
where Self : Equatable {
    
    func contentView() -> _SContentView<Self>
}

extension SContentConfiguration {
    
    func makeContentView() -> UIView & UIContentView {
        contentView()
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        self
    }
}
