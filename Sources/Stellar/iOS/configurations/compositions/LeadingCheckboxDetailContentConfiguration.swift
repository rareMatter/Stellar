//
//  LeadingCheckboxDetailContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/19/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// A composed content configuration designed specifically for use displaying Goals. Title and secondary text which appears below the title are displayed, with optional trailing views which follow the secondary text content. The title content is represented using a `LeadingButtonLabelContentConfiguration`, secondary text content uses `LeadingViewLabelContentConfiguration`.
struct LeadingCheckboxDetailContentConfiguration: SContentConfiguration, Equatable {

    // -- content
    var titleTextContent: LeadingButtonLabelContentConfiguration
    var secondaryTextContent: LeadingViewLabelContentConfiguration
	
    var trailingViews: [UIView] = []

    var configurationState: UICellConfigurationState = .init(traitCollection: .current)

    func updated(for state: UIConfigurationState) -> LeadingCheckboxDetailContentConfiguration {
		var updatedContentConfiguration = self
		
        if let cellState = state as? UICellConfigurationState {
            updatedContentConfiguration.configurationState = cellState
		}
        
        updatedContentConfiguration.titleTextContent = titleTextContent
            .updated(for: state)
        updatedContentConfiguration.secondaryTextContent = secondaryTextContent
            .updated(for: state)
		
        return updatedContentConfiguration
	}
}
// MARK: - content view
extension LeadingCheckboxDetailContentConfiguration {
    
    func contentView() -> _SContentView<Self> {
        
        let hStack: UIStackView = {
           let hStack = UIStackView(arrangedSubviews: [])
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.axis = .horizontal
            hStack.distribution = .fillProportionally
            hStack.alignment = .center
            
            return hStack
        }()
        
        let titleTextContentView: _SContentView<LeadingButtonLabelContentConfiguration> = {
            let view = titleTextContent
                .contentView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.directionalLayoutMargins = .zero
            return view
        }()
        
        let secondaryTextContentView: _SContentView<LeadingViewLabelContentConfiguration> = {
            let view = secondaryTextContent
                .contentView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.directionalLayoutMargins = .zero
            return view
        }()
        
        let vStack: UIStackView = {
            let vStack = UIStackView(arrangedSubviews: [])
            vStack.translatesAutoresizingMaskIntoConstraints = false
            vStack.axis = .vertical
            vStack.distribution = .fill
            vStack.alignment = .fill
            vStack.setContentCompressionResistancePriority(.required, for: .horizontal)
            vStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
            return vStack
        }()
        
        let trailingImageHStack: UIStackView = {
            let hStack = UIStackView(frame: .zero)
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.axis = .horizontal
            hStack.distribution = .fillProportionally
            hStack.alignment = .firstBaseline
            hStack.spacing = 6
            hStack.setContentHuggingPriority(.required, for: .horizontal)
            hStack.setContentCompressionResistancePriority(.required, for: .horizontal)
            return hStack
        }()
        var trailingViews: [UIView] = [] {
            willSet {
                trailingViews.forEach { (view) in
                    view.removeFromSuperview()
                }
            }
            didSet {
                trailingViews.forEach { (view) in
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.setContentCompressionResistancePriority(.required, for: .horizontal)
                    view.setContentHuggingPriority(.required, for: .horizontal)
                    trailingImageHStack.addArrangedSubview(view)
                }
            }
        }
        
        return _SContentView<Self>(configuration: self) { contentView in
            contentView.addSubview(hStack)
            
            vStack.addArrangedSubview(titleTextContentView)
            vStack.addArrangedSubview(secondaryTextContentView)
            
            hStack.addArrangedSubview(vStack)
            hStack.addArrangedSubview(trailingImageHStack)
            
        } handleConstraintUpdate: { contentView, isFirstSetup in
            guard isFirstSetup else { return }
            
            hStack.snp.makeConstraints { make in
                make.top.equalTo(contentView.snp.topMargin)
                make.bottom.equalTo(contentView.snp.bottomMargin)
                make.leading.equalTo(contentView.snp.leadingMargin)
                make.trailing.equalTo(contentView.snp.trailingMargin)
            }

        } handleConfigurationUpdate: { oldConfig, updatedConfig, contentView in
            titleTextContentView.configuration = updatedConfig.titleTextContent
            secondaryTextContentView.configuration = updatedConfig.secondaryTextContent
            
            // trailing views
            if trailingViews != updatedConfig.trailingViews {
                trailingViews = updatedConfig.trailingViews
            }
        }
    }
}

// MARK: SPrimitiveRepresentable
extension SLeadingCheckboxLabel: UIKitContentRenderer {
    
    func mountContent(on target: UIKitRenderableContent) {
        let buttonContentConfig = ButtonContentConfiguration(
            primaryAction: .init(self.checkboxActionHandler),
            image: self.checkboxImage,
            backgroundColor: self.checkboxBackgroundColor)
        
        let leadingViewLabelContentConfig: LeadingViewLabelContentConfiguration =
            .init(title: self.subtitle,
                  leadingView: self.subtitleLeadingView,
                  horizontalAlignment: .leading)
        
        target.contentConfiguration =
            LeadingCheckboxDetailContentConfiguration(
                titleTextContent: .init(title: self.title,
                                        buttonConfiguration: buttonContentConfig),
                secondaryTextContent: leadingViewLabelContentConfig,
                trailingViews: self.trailingViews)
    }
}

// MARK: - Live Preview support
#if DEBUG
import SwiftUI

struct GoalRowContentConfigurationViewRepresentable: UIViewRepresentable {
	func makeUIView(context: Context) -> UIView {
        let leadingButtonLabelConfig = LeadingButtonLabelContentConfiguration(title: "a title", buttonConfiguration: .init())
        let config = LeadingCheckboxDetailContentConfiguration(titleTextContent: leadingButtonLabelConfig,
                                                 secondaryTextContent: .init(title: "Secondary title",
                                                                             leadingView: UIImageView(image: .init(systemName: "glasses")), horizontalAlignment: .leading))
		
		return config.makeContentView()
	}
	
	func updateUIView(_ uiView: UIView, context: Context) {}
}

struct GoalRowContentConfiguration_Preview: PreviewProvider {
	static var previews: some View {
		GoalRowContentConfigurationViewRepresentable()
			.previewLayout(.sizeThatFits)
	}
}
#endif
