//
//  LeadingButtonContentConfiguration.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 10/19/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

/// A configuration which displays a leading button before a label.
public
struct LeadingButtonLabelContentConfiguration: UIContentConfiguration, Equatable {
	
    public var labelConfiguration: TitleTextConfiguration
    public var buttonConfiguration: ButtonConfiguration

    public var labelProperties: TextProperties
	
    public
    init(labelConfiguration: TitleTextConfiguration, buttonConfiguration: ButtonConfiguration, labelProperties: TextProperties = .init(font: .preferredFont(forTextStyle: .title1))) {
        self.labelConfiguration = labelConfiguration
        self.buttonConfiguration = buttonConfiguration
        self.labelProperties = labelProperties
    }
    
    public func makeContentView() -> UIView & UIContentView {
		ContentView(leadingButtonLabelContentConfiguration: self)
	}
	
    public func updated(for state: UIConfigurationState) -> Self {
		self
	}
}
// MARK: - content view
extension LeadingButtonLabelContentConfiguration {
	private final class ContentView: UIView, UIContentView {
		
		// -- views
        /// The root view for this content view.
        private let hStack: UIStackView = {
            let hStack = UIStackView(frame: .zero)
            hStack.axis = .horizontal
            hStack.alignment = .fill
            hStack.translatesAutoresizingMaskIntoConstraints = false
            return hStack
        }()
        
		private lazy var leadingButton: UIButton = {
			let button = UIButton(type: .custom, primaryAction: leadingButtonLabelContentConfiguration.buttonConfiguration.primaryAction)
			button.translatesAutoresizingMaskIntoConstraints = false
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentCompressionResistancePriority(.required, for: .horizontal)
			return button
		}()
		private lazy var label: UILabel = {
			let label = UILabel(frame: .zero)
			label.numberOfLines = 0
			label.adjustsFontForContentSizeCategory = true
			label.translatesAutoresizingMaskIntoConstraints = false
			return label
		}()
		
		// -- configuration
		var configuration: UIContentConfiguration {
			get { leadingButtonLabelContentConfiguration }
			set {
				guard let newConfig = newValue as? LeadingButtonLabelContentConfiguration else {
					assertionFailure("Expected \(leadingButtonLabelContentConfiguration.self)")
					return
				}
				guard newConfig != leadingButtonLabelContentConfiguration else {
					return
				}
				leadingButtonLabelContentConfiguration = newConfig
			}
		}
		
		private var leadingButtonLabelContentConfiguration: LeadingButtonLabelContentConfiguration {
			didSet {
                updateViewState(from: oldValue, to: leadingButtonLabelContentConfiguration)
			}
		}
		
		init(leadingButtonLabelContentConfiguration: LeadingButtonLabelContentConfiguration) {
			self.leadingButtonLabelContentConfiguration = leadingButtonLabelContentConfiguration
			
			super.init(frame: .zero)
			
			configureHierarchy()
            updateViewState(from: leadingButtonLabelContentConfiguration, to: leadingButtonLabelContentConfiguration)
			setNeedsUpdateConstraints()
		}
		
		@available(*, unavailable)
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		private func configureHierarchy() {
            addSubview(hStack)
            hStack.addArrangedSubview(leadingButton)
            hStack.addArrangedSubview(label)
		}
		
		// MARK: - view lifecycle
		
        private func updateViewState(from oldConfig: LeadingButtonLabelContentConfiguration, to newConfig: LeadingButtonLabelContentConfiguration) {
			label.text = leadingButtonLabelContentConfiguration.labelConfiguration.text
			label.font = leadingButtonLabelContentConfiguration.labelProperties.font
			
            newConfig.buttonConfiguration.map(to: leadingButton, from: oldConfig.buttonConfiguration)
		}
		
		
        private var needsConstraintsSetup = true
		override func updateConstraints() {
			if needsConstraintsSetup {
                hStack.snp.makeConstraints { (make) in
                    make.directionalMargins.equalToSuperview()
                }
				needsConstraintsSetup = false
			}
			super.updateConstraints()
		}
	}
}
