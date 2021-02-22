//
//  LeadingViewLabelContentConfiguration.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 10/19/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit

/// Displays a leading view before a label.
public
struct LeadingViewLabelContentConfiguration: UIContentConfiguration, Equatable {
	
	public var leadingView: UIView
	/// Whether the leading view should be vertically aligned to the label using first baselines. If false, the views will be aligned by their centers.
	public var isFirstBaselineLayout = true
	
	public var labelConfiguration: TitleTextConfiguration
	public var labelProperties: TextProperties = .init(font: .preferredFont(forTextStyle: .title1))
	
    public
    init(leadingView: UIView, labelConfiguration: TitleTextConfiguration) {
        self.leadingView = leadingView
        self.labelConfiguration = labelConfiguration
    }
    
    public func makeContentView() -> UIView & UIContentView {
		ContentView(leadingViewLabelContentConfiguration: self)
	}
	
    public func updated(for state: UIConfigurationState) -> Self {
		self
	}
}
// MARK: - content view
extension LeadingViewLabelContentConfiguration {
	private final class ContentView: UIView, UIContentView {
		// -- views
		private let hStack: UIStackView = {
			let hStack = UIStackView(frame: .zero)
			hStack.translatesAutoresizingMaskIntoConstraints = false
			hStack.axis = .horizontal
			hStack.distribution = .fill
			return hStack
		}()
		
		private var leadingView: UIView {
			willSet {
				guard newValue != leadingView else { return }
				leadingView.removeFromSuperview()
			}
			didSet {
				leadingView.translatesAutoresizingMaskIntoConstraints = false
				leadingView.setContentHuggingPriority(.required, for: .horizontal)
				leadingView.setContentCompressionResistancePriority(.required, for: .horizontal)
				hStack.insertArrangedSubview(leadingView, at: 0)
			}
		}
		private lazy var label: UILabel = {
			let label = UILabel(frame: .zero)
			label.numberOfLines = 1
			label.adjustsFontForContentSizeCategory = true
			label.translatesAutoresizingMaskIntoConstraints = false
			label.lineBreakMode = .byTruncatingTail
			return label
		}()
		
		// -- configuration
		var configuration: UIContentConfiguration {
			get { _configuration }
			set {
				guard let newConfig = newValue as? LeadingViewLabelContentConfiguration else {
					assertionFailure("Expected \(_configuration.self)")
					return
				}
				guard newConfig != _configuration else {
					return
				}
				_configuration = newConfig
			}
		}
		
		private var _configuration: LeadingViewLabelContentConfiguration {
			willSet {
				updateViewState(from: _configuration, to: newValue)
			}
		}
		
		init(leadingViewLabelContentConfiguration: LeadingViewLabelContentConfiguration) {
			self._configuration = leadingViewLabelContentConfiguration
			self.leadingView = leadingViewLabelContentConfiguration.leadingView
			
			super.init(frame: .zero)
			
			configureHierarchy()
			updateViewState(from: leadingViewLabelContentConfiguration, to: leadingViewLabelContentConfiguration)
			setNeedsUpdateConstraints()
		}
		
		@available(*, unavailable)
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		private func configureHierarchy() {
   			addSubview(hStack)
			hStack.addArrangedSubview(leadingView)
			hStack.addArrangedSubview(label)
		}
		
		// MARK: - view lifecycle
		
		private func updateViewState(from currentConfig: LeadingViewLabelContentConfiguration, to updatedConfig: LeadingViewLabelContentConfiguration) {
			if updatedConfig.isFirstBaselineLayout {
				hStack.alignment = .firstBaseline
			}
			else {
				hStack.alignment = .center
			}
			
			label.text = updatedConfig.labelConfiguration.text
			label.font = updatedConfig.labelProperties.font
			
			leadingView = updatedConfig.leadingView
			hStack.setCustomSpacing(8, after: leadingView)
			
			setNeedsUpdateConstraints()
		}
		
        /// A flag for whether constraints need initial setup.
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
