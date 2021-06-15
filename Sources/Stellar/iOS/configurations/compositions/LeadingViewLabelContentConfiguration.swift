//
//  LeadingViewLabelContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/19/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

/// Displays a leading view before a label.
struct LeadingViewLabelContentConfiguration: SContentConfiguration, Equatable {
    
    var title: String
    var leadingView: UIView
    
    var horizontalAlignment: SHorizontalAlignment
    var padding = 8
    
    var labelProperties: TextProperties = .init(font: .preferredFont(forTextStyle: .title1))
    
    var configurationState: UICellConfigurationState = .init(traitCollection: .current)
}

// MARK: - content view
extension LeadingViewLabelContentConfiguration {
    
    func contentView() -> _SContentView<Self> {
        
        let hStack: UIStackView = {
            let hStack = UIStackView(arrangedSubviews: [])
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.axis = .horizontal
            hStack.distribution = .fill
            hStack.alignment = .center
            hStack.spacing = CGFloat(padding)
            return hStack
        }()
        
        #warning("TODO: this is likely better being its own content view.")
        var leadingView = self.leadingView {
            willSet {
                guard newValue != leadingView else { return }
                leadingView.removeFromSuperview()
            }
            didSet {
                leadingView.translatesAutoresizingMaskIntoConstraints = false
                leadingView.setContentCompressionResistancePriority(.required, for: .horizontal)
                leadingView.setContentHuggingPriority(.required, for: .horizontal)
                hStack.insertArrangedSubview(leadingView, at: 0)
            }
        }
        
        let label: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingTail
            label.adjustsFontForContentSizeCategory = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        return _SContentView<Self>(configuration: self) { contentView in
            
            contentView.addSubview(hStack)

            if leadingView.superview == nil {
                hStack.addArrangedSubview(leadingView)
            }
            hStack.addArrangedSubview(label)
            
        } handleConstraintUpdate: { contentView, isFirstSetup in
            
            hStack.snp.remakeConstraints { make in
                
                switch horizontalAlignment {
                    case .center:
                        make.centerXWithinMargins.equalToSuperview()
                    case .leading:
                        make.leading.equalTo(contentView.snp.leadingMargin).priority(.required)
                        make.trailing.lessThanOrEqualToSuperview().priority(.required)
                    case .trailing:
                        make.trailing.equalTo(contentView.snp.trailingMargin).priority(.required)
                        make.leading.lessThanOrEqualToSuperview().priority(.required)
                }
                
                make.top.equalTo(contentView.snp.topMargin)
                make.bottom.equalTo(contentView.snp.bottomMargin)
            }
            
        } handleConfigurationUpdate: { oldConfig, updatedConfig, contentView in
            label.text = updatedConfig.title
            label.font = updatedConfig.labelProperties.font
            leadingView = updatedConfig.leadingView
            if oldConfig?.horizontalAlignment != updatedConfig.horizontalAlignment {
                contentView.setNeedsUpdateConstraints()
            }
            if oldConfig?.padding != updatedConfig.padding {
                hStack.spacing = CGFloat(updatedConfig.padding)
            }
        }
    }
}

// MARK: SPrimitiveRepresentable
extension SLeadingViewLabel: UIKitContentRenderer {
    
    func mountContent(on target: UIKitRenderableContent) {
        target.contentConfiguration =
            LeadingViewLabelContentConfiguration(
                title: text,
                leadingView: leadingView,
                horizontalAlignment: horizontalAlignment)
    }
}
