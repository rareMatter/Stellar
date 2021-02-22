//
//  CenteredLeadingImageContentConfiguration.swift
//  life-tool-1-iOS
//
//  Created by Jesse Spencer on 1/29/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

/// A composed content configuration which accepts a `LeadingViewLabelContentConfiguration` and centers its content.
public
struct CenteredLeadingViewContentConfiguration: UIContentConfiguration, Equatable {
    
    var contentConfiguration: LeadingViewLabelContentConfiguration
    
    public
    init(contentConfiguration: LeadingViewLabelContentConfiguration) {
        self.contentConfiguration = contentConfiguration
    }
    
    public func makeContentView() -> UIView & UIContentView {
        ContentView(configuration: self)
    }
    
    public func updated(for state: UIConfigurationState) -> Self {
        self
    }
}
private
extension CenteredLeadingViewContentConfiguration {
    final class ContentView: UIView, UIContentView {
        // -- views
        private let containerView: UIView = {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // -- content view
        private let leadingViewContentView: UIView & UIContentView
        
        // -- config
        var configuration: UIContentConfiguration {
            get { _configuration }
            set {
                guard let newConfig = newValue as? CenteredLeadingViewContentConfiguration else {
                    assertionFailure("Expected \(CenteredLeadingViewContentConfiguration.self)")
                    return
                }
                guard newConfig != _configuration else { return }
                _configuration = newConfig
            }
        }
        private var _configuration: CenteredLeadingViewContentConfiguration {
            didSet {
                updateWithConfiguration()
            }
        }
        
        // MARK: - init
        
        init(configuration: CenteredLeadingViewContentConfiguration) {
            self._configuration = configuration
            self.leadingViewContentView = _configuration.contentConfiguration.makeContentView()
            
            super.init(frame: .zero)
            
            addSubview(containerView)
            containerView.addSubview(leadingViewContentView)
            
            updateWithConfiguration()
            setNeedsUpdateConstraints()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("\(#function) has not been implemented")
        }
        
        // MARK: - view lifecycle
        
        private func updateWithConfiguration() {
            leadingViewContentView.configuration = _configuration.contentConfiguration
        }
        
        /// A flag for constraints needing one-time setup.
        var needsConstraintsSetup = true
        override func updateConstraints() {

            if needsConstraintsSetup {
                containerView.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                }
                
                leadingViewContentView.snp.makeConstraints { (make) in
                    make.center.equalToSuperview()
                    make.top.bottom.lessThanOrEqualToSuperview()
                    make.leading.trailing.lessThanOrEqualToSuperview()
                }
                
                needsConstraintsSetup = false
            }
            super.updateConstraints()
        }
    }
}
