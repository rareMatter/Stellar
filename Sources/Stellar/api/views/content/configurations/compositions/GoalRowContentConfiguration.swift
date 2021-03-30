//
//  GoalRowContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/19/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// A composed content configuration designed specifically for use displaying Goals. Title and secondary text which appears below the title are displayed, with optional trailing views which follow the secondary text content. The title content is represented using a `LeadingButtonLabelContentConfiguration`, secondary text content uses `LeadingViewLabelContentConfiguration`.
public
struct GoalRowContentConfiguration: SContentConfiguration, Equatable {
	public static var defaultPreferredTitleFont: UIFont {
		.preferredFont(forTextStyle: .title2)
	}
    public static var defaultPreferredSecondaryFont: UIFont {
		.preferredFont(forTextStyle: .title3)
	}
	
	// -- content
    public var titleTextContent: LeadingButtonLabelContentConfiguration
    public var secondaryTextContent: LeadingViewLabelContentConfiguration?
	
    public var trailingViews: [UIView] = []

    public var isUserInteractionEnabled = true
	
    public
    init(titleTextContent: LeadingButtonLabelContentConfiguration, secondaryTextContent: LeadingViewLabelContentConfiguration? = nil, trailingViews: [UIView] = [], isUserInteractionEnabled: Bool = true) {
        self.titleTextContent = titleTextContent
        self.secondaryTextContent = secondaryTextContent
        self.trailingViews = trailingViews
        self.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    public func makeContentView() -> UIView & UIContentView {
		ContentView(goalRowContentConfiguration: self)
	}
	
    public func updated(for state: UIConfigurationState) -> GoalRowContentConfiguration {
		var contentConfiguration = self
		if let cellState = state as? UICellConfigurationState {
			contentConfiguration.isUserInteractionEnabled = !cellState.isEditing
		}
		return contentConfiguration
	}
}
// MARK: - content view
extension GoalRowContentConfiguration {
	private final class ContentView: UIView, UIContentView {
		// -- views
		// content views
		private let titleTextContentView: UIView & UIContentView
		private var secondaryTextContentView: (UIView & UIContentView)? {
			didSet {
				secondaryTextContentView?.translatesAutoresizingMaskIntoConstraints = false
			}
		}
		
		private var trailingImageHStack: UIStackView = {
			let hStack = UIStackView(frame: .zero)
			hStack.translatesAutoresizingMaskIntoConstraints = false
			hStack.axis = .horizontal
			hStack.distribution = .fill
			hStack.alignment = .firstBaseline
			hStack.spacing = 6
			return hStack
		}()
		private var trailingViews: [UIView] = []
		
        private let spacer: UIView = {
            let spacer = UIView(frame: .zero)
            spacer.translatesAutoresizingMaskIntoConstraints = false
            spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
            spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            spacer.backgroundColor = .none
            return spacer
        }()
        
		// -- config
		var configuration: UIContentConfiguration {
			get { _configuration }
			set {
				guard let newConfig = newValue as? GoalRowContentConfiguration else {
					assertionFailure("Expected \(GoalRowContentConfiguration.self)")
					return
				}
				guard newConfig != _configuration else { return }
				_configuration = newConfig
			}
		}
		private var _configuration: GoalRowContentConfiguration {
			didSet {
				updateForConfiguration()
			}
		}
		
		// MARK: - init
		
		init(goalRowContentConfiguration: GoalRowContentConfiguration) {
			self._configuration = goalRowContentConfiguration
			self.titleTextContentView = _configuration.titleTextContent.makeContentView()
			
			super.init(frame: .zero)
			
			directionalLayoutMargins = .init(top: 12, leading: 8, bottom: 12, trailing: 8)
			configureHierarchy()
			updateForConfiguration()
			setNeedsUpdateConstraints()
		}
		
		@available(*, unavailable)
		required init?(coder: NSCoder) {
			fatalError("\(#function) has not been implemented")
		}
		
		// MARK: - view lifecycle
		
		private func configureHierarchy() {
			titleTextContentView.translatesAutoresizingMaskIntoConstraints = false
			addSubview(titleTextContentView)
			addSubview(trailingImageHStack)
            
            trailingImageHStack.addArrangedSubview(spacer)
		}
		
		private func updateForConfiguration() {
			titleTextContentView.configuration = _configuration.titleTextContent
			
			if let secondaryTextContent = _configuration.secondaryTextContent {
				if secondaryTextContentView == nil {
					secondaryTextContentView = secondaryTextContent.makeContentView()
					addSubview(secondaryTextContentView!)
					setNeedsUpdateConstraints()
				}
			}
			
			// trailing views
			if trailingViews != _configuration.trailingViews {
				trailingViews.forEach { (view) in
					view.removeFromSuperview()
				}
				trailingViews = _configuration.trailingViews
				trailingViews.forEach { (view) in
					view.translatesAutoresizingMaskIntoConstraints = false
					trailingImageHStack.addArrangedSubview(view)
				}
			}
		}
		
		/// A flag for constraints needing one-time setup.
		var needsConstraintsSetup = true
		
		override func updateConstraints() {
			if needsConstraintsSetup {
                titleTextContentView.snp.makeConstraints { (make) in
                    make.leading.equalTo(snp.leadingMargin)
                    make.trailing.equalTo(snp.trailingMargin)
                    make.bottom.equalTo(snp.bottomMargin).priority(.low)
                    make.top.equalTo(snp.topMargin)
                }
                trailingImageHStack.snp.makeConstraints { (make) in
                    make.top.equalTo(titleTextContentView.snp.bottom)
                    make.bottom.equalTo(snp.bottomMargin)
                    make.trailing.equalTo(snp.trailingMargin)
                }
                
				needsConstraintsSetup = false
			}
			
			if let secondaryTextContentView = secondaryTextContentView {
				secondaryTextContentView.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleTextContentView.snp.bottom)
					make.bottom.equalTo(snp.bottomMargin)
                    make.leading.equalTo(snp.leadingMargin)
                    make.trailing.equalTo(trailingImageHStack.snp.leading)
				}
			}
			
			super.updateConstraints()
		}
	}
}


// MARK: - Live Preview support
#if DEBUG
import SwiftUI

struct GoalRowContentConfigurationViewRepresentable: UIViewRepresentable {
	func makeUIView(context: Context) -> UIView {
        let leadingButtonLabelConfig = LeadingButtonLabelContentConfiguration(labelConfiguration: .init(text: "title"), buttonConfiguration: .init(primaryAction: .init(handler: { (_) in
            
        }), image: nil, imageProperties: .init(preferredSymbolConfiguration: .init(font: .preferredFont(forTextStyle: .title1)))))
		let config = GoalRowContentConfiguration(titleTextContent: leadingButtonLabelConfig)
		
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
