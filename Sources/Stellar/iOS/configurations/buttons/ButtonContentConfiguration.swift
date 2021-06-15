//
//  ButtonContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/1/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import UIKit

struct ButtonContentConfiguration: SContentConfiguration, Hashable {

    var primaryAction: SHashableClosure = .init {}

    var title: String?
    
    var image: UIImage?
    var imageProperties: ImageProperties = .init(preferredSymbolConfiguration: .init(textStyle: .title3))

    var backgroundColor: UIColor?

    var configurationState: UICellConfigurationState = .init(traitCollection: .current)
}

// MARK: content view
extension ButtonContentConfiguration {
    
    func contentView() -> _SContentView<Self> {
        
        let button: _SButton = {
            let button = _SButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(.label, for: .normal)
            return button
        }()
        
        return .init(configuration: self) { contentView in
            contentView.addSubview(button)
        } handleConstraintUpdate: { contentView, isFirstSetup in
            guard isFirstSetup else { return }
            button.snp.makeConstraints { make in
                make.directionalEdges.equalTo(contentView.snp.directionalMargins)
                make.top.equalTo(contentView.snp.topMargin)
                make.bottom.equalTo(contentView.snp.bottomMargin)
            }
        } intrinsicContentSizeProvider: {
            button.intrinsicContentSize
        } handleConfigurationUpdate: { oldConfig, updatedConfig, contentView in
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
                .configurationState
                .isSelected
            button.isEnabled = !updatedConfig
                .configurationState
                .isDisabled
        }
    }
}

// MARK: - SContent mapping
extension SButton: UIKitContentRenderer {
    
    func mountContent(on target: UIKitRenderableContent) {
        target.contentConfiguration =
            ButtonContentConfiguration(primaryAction: .init(actionHandler),
                                       title: title,
                                       image: image,
                                       backgroundColor: backgroundColor)
    }
}
