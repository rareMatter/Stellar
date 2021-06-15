//
//  LeadingButtonContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/19/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

/// A configuration which displays a leading button before a label.
struct LeadingButtonLabelContentConfiguration: SContentConfiguration, Equatable {
	
    var title: String
    var buttonConfiguration: ButtonContentConfiguration

    var padding = 8
    
    var labelProperties: TextProperties = .init(font: .preferredFont(forTextStyle: .title1))
    
    var configurationState: UICellConfigurationState = .init(traitCollection: .current)
    
    func updated(for state: UIConfigurationState) -> LeadingButtonLabelContentConfiguration {
        var mutated = self
        
        if let cellState = state as? UICellConfigurationState {
            mutated.configurationState = cellState
        }
        
        mutated.buttonConfiguration = buttonConfiguration
            .updated(for: state)
        
        return mutated
    }
}
// MARK: - content view
extension LeadingButtonLabelContentConfiguration {
    
    func contentView() -> _SContentView<Self> {
        
        /// The root view for this content view.
        let hStack: UIStackView = {
            let hStack = UIStackView(frame: .zero)
            hStack.axis = .horizontal
            hStack.alignment = .fill
            hStack.distribution = .fill
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.spacing = CGFloat(padding)
            return hStack
        }()
        
        let leadingButton: _SContentView<ButtonContentConfiguration> = {
            let button = self
                .buttonConfiguration
                .contentView()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
            button.directionalLayoutMargins = .zero
            return button
        }()
        let label: UILabel = {
            let label = UILabel(frame: .zero)
            label.numberOfLines = 2
            label.adjustsFontForContentSizeCategory = true
            label.translatesAutoresizingMaskIntoConstraints = false
            label.lineBreakMode = .byTruncatingTail
            return label
        }()
        
        return _SContentView<Self>(configuration: self) { contentView in
            contentView.addSubview(hStack)
            hStack.addArrangedSubview(leadingButton)
            hStack.addArrangedSubview(label)
        } handleConstraintUpdate: { contentView, isFirstSetup in
            guard isFirstSetup else { return }
            hStack.snp.makeConstraints { (make) in
                make.leading.equalTo(contentView.snp.leadingMargin)
                make.trailing.equalTo(contentView.snp.trailingMargin)
                make.top.equalTo(contentView.snp.topMargin)
                make.bottom.equalTo(contentView.snp.bottomMargin)
            }
        } handleConfigurationUpdate: { oldConfig, updatedConfig, contentView in
            label.text = updatedConfig.title
            label.font = updatedConfig.labelProperties.font
            
            leadingButton.configuration = updatedConfig.buttonConfiguration
            
            if oldConfig?.padding != updatedConfig.padding {
                hStack.spacing = CGFloat(updatedConfig.padding)
            }
        }
    }
}

// MARK: SPrimitiveRepresentable
extension SLeadingButtonLabel: UIKitContentRenderer {
    
    func mountContent(on target: UIKitRenderableContent) {
        let buttonContentConfig = ButtonContentConfiguration(
            primaryAction: .init(actionHandler),
            image: buttonImage,
            backgroundColor: buttonBackgroundColor)
        
        target.contentConfiguration =
            LeadingButtonLabelContentConfiguration(
                title: text,
                buttonConfiguration: buttonContentConfig)
    }
}
