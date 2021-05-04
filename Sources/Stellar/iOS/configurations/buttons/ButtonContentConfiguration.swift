//
//  ButtonContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/1/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

public
struct ButtonContentConfiguration: SContentConfiguration, Hashable {

    public
    var primaryAction: SHashableClosure = .init {}

    public
    var title: String? = nil
    public
    var image: UIImage? = nil
    public
    var imageProperties: ImageProperties = .init(preferredSymbolConfiguration: .unspecified)

    public
    var backgroundColor: UIColor? = nil

    public
    var isSelected = false
    public
    var isDisabled = false
    
    public
    init() {}
    
    // -- content configuration
    public
    func makeContentView() -> UIView & UIContentView {
        Self.contentView(for: self)
    }
    
    public
    func updated(for state: UIConfigurationState) -> ButtonContentConfiguration {
        self
    }
}

// MARK: content view
extension ButtonContentConfiguration {
    
    static
    func contentView(for configuration: Self) -> UIContentView & UIView {
        let button: _SButton = {
            let button = _SButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        return _SContentView<Self>(configuration: configuration) { oldConfig, updatedConfig, contentView in
            button.onPrimaryAction(updatedConfig
                                    .primaryAction
                                    .handler)
            button.setTitle(updatedConfig.title,
                            for: .normal)
            button.setImage(updatedConfig.image,
                            for: .normal)
            button.setPreferredSymbolConfiguration(updatedConfig
                                                    .imageProperties
                                                    .preferredSymbolConfiguration,
                                                   forImageIn: .normal)
            button.backgroundColor = updatedConfig
                .backgroundColor
            button.isSelected = updatedConfig
                .isSelected
            button.isEnabled = !updatedConfig
                .isDisabled
        } configureViewHierarchy: { contentView in
            contentView.addSubview(button)
        } handleConstraintUpdate: { contentView, isFirstSetup in
            guard isFirstSetup else { return }
            button.snp.makeConstraints { make in
                make.directionalEdges.equalToSuperview()
            }
        }

    }
}
