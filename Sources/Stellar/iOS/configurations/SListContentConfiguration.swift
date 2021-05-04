//
//  SListContentConfiguration.swift
//  
//
//  Created by Jesse Spencer on 3/11/21.
//

import UIKit

/// A content configuration for providing row content to a list view.
public
struct SListContentConfiguration: SContentConfiguration, Equatable {
    
    public
    var listContentConfiguration: UIListContentConfiguration
    
    public
    init(listContentConfiguration: UIListContentConfiguration) {
        self.listContentConfiguration = listContentConfiguration
    }
    
    public func makeContentView() -> UIView & UIContentView {
        listContentConfiguration.makeContentView()
    }
    
    public func updated(for state: UIConfigurationState) -> SListContentConfiguration {
        self
    }
}
