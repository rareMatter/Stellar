//
//  RMContentView.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/1/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

/** A view intended to be used with UIContentConfigurations. This view class provides the backbone for creating a custom content view to be paired with a corresponding configuration, storing a generic configuration property and allowing response to updates via a handler closure. By accepting a generic configuration property, type equality can be ensured when updated configurations are provided. Subclass as needed.
 
 Use this class as a starting point for creating custom content views, either by subclassing or adding subviews as needed.
 - Important: Instance and type equality are checked against updated configuration instances before committing an update and calling the update handler.
*/
class ContentView<Configuration: UIContentConfiguration & Equatable>: UIView, UIContentView {
    
    typealias UpdateHandler = (_ from: Configuration, _ to: Configuration) -> Void
    
    // -- config
    var configuration: UIContentConfiguration {
        get { _configuration }
        set {
            guard let newConfig = newValue as? Configuration else {
                assertionFailure("Expected \(Configuration.self).")
                return
            }
            guard newConfig != _configuration else { return }
            _configuration = newConfig
        }
    }
    private var _configuration: Configuration {
        didSet {
            updateForConfiguration(from: oldValue, to: _configuration)
        }
    }
    
    // -- update handler
    /// A closure that is called after the configuration is changed.
    var handleUpdate: UpdateHandler
    
    init(configuration: Configuration, handleConfigurationChange: @escaping UpdateHandler) {
        self._configuration = configuration
        self.handleUpdate = handleConfigurationChange
        
        super.init(frame: .zero)
        
        updateForConfiguration(from: configuration, to: configuration)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - updates
private
extension ContentView {
    func updateForConfiguration(from oldConfig: Configuration, to newConfig: Configuration) {
        handleUpdate(oldConfig, newConfig)
    }
}
