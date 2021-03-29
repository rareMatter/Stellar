//
//  LeadingViewTextEditorContentConfiguration.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 10/28/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit
import SnapKit
import Combine

/// Displays a leading view before a text editor view.
public
struct LeadingViewTextEditorContentConfiguration: SDynamicContentConfiguration {

    public var sizeDidChange: () -> Void = { debugPrint("Blank `sizeDidChange` handler called.") }
    
	public var leadingView: UIView
	
    public var text: String
    public var placeholderText: String
    public var font: UIFont
	
    public
    init(leadingView: UIView, text: String = "", placeholderText: String = "A placeholder...", font: UIFont = .preferredFont(forTextStyle: .title1)) {
        self.leadingView = leadingView
        self.text = text
        self.placeholderText = placeholderText
        self.font = font
    }
    
    private var textViewConfiguration: TextViewConfiguration = {
        var config = TextViewConfiguration()
        config.isEditable = true
        config.isScrollable = false
        return config
    }()
	
    public func makeContentView() -> UIView & UIContentView {
		ContentView(leadingViewTextEditorContentConfiguration: self)
	}
	
    public func updated(for state: UIConfigurationState) -> LeadingViewTextEditorContentConfiguration {
		self
	}
}

// MARK: - equatable
extension LeadingViewTextEditorContentConfiguration: Equatable {
    
    public
    static
    func ==(lhs: LeadingViewTextEditorContentConfiguration, rhs: LeadingViewTextEditorContentConfiguration) -> Bool {
        lhs.leadingView == rhs.leadingView &&
        lhs.text == rhs.text &&
        lhs.placeholderText == rhs.placeholderText &&
        lhs.font == rhs.font
    }
}

// MARK: - api
public
extension LeadingViewTextEditorContentConfiguration {
    
    func onTextChange(_ handler: @escaping (String) -> Void) -> Self {
        self.textViewConfiguration.delegate.didChange = { textView in
            sizeDidChange()
            handler(textView.text)
        }
        return self
    }
    
    func inputAccessory(_ view: UIView) -> Self {
        var modified = self
        modified.textViewConfiguration.inputAccessoryView = view
        return modified
    }
}

// MARK: - content view
private
extension LeadingViewTextEditorContentConfiguration {
	private final class ContentView: UIView, UIContentView, ResponderNotifier {
		// -- views
		private var leadingView: UIView
		private lazy var textView: KMPlaceholderTextView = {
			let textView = KMPlaceholderTextView(frame: .zero)
			textView.translatesAutoresizingMaskIntoConstraints = false
			textView.adjustsFontForContentSizeCategory = true
			return textView
		}()
		
		// -- configuration
		private var _configuration: LeadingViewTextEditorContentConfiguration {
			didSet {
				updateViewState()
			}
		}
		
		var configuration: UIContentConfiguration {
			get { _configuration }
			set {
				guard let newConfig = newValue as? LeadingViewTextEditorContentConfiguration else {
					assertionFailure("Expected \(LeadingViewTextEditorContentConfiguration.self)")
					return
				}
				guard newConfig != _configuration else {
					return
				}
				_configuration = newConfig
			}
		}
		
		// MARK: - init
		
		init(leadingViewTextEditorContentConfiguration: LeadingViewTextEditorContentConfiguration) {
			self._configuration = leadingViewTextEditorContentConfiguration
			self.leadingView = _configuration.leadingView
			
			super.init(frame: .zero)
			
			configureHierarchy()
			updateViewState()
		}
		
		@available(*, unavailable)
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		private func configureHierarchy() {
			addSubview(leadingView)
			addSubview(textView)
		}
		
		// MARK: - view lifecycle
		
		private func updateViewState() {
			textView.text = _configuration.text
			textView.placeholder = _configuration.placeholderText
			textView.font = _configuration.font
			textView.delegate = _configuration.textViewConfiguration.delegate
			updatePublishers()
			textView.inputAccessoryView = _configuration.textViewConfiguration.inputAccessoryView
			textView.isEditable = _configuration.textViewConfiguration.isEditable
			textView.isScrollEnabled = _configuration.textViewConfiguration.isScrollable
			
			if leadingView != _configuration.leadingView {
				leadingView.removeFromSuperview()
				leadingView = _configuration.leadingView
				addSubview(leadingView)
				setNeedsUpdateConstraints()
			}
		}
		
		override func updateConstraints() {
			
			leadingView.snp.remakeConstraints { (make) in
				make.leading.equalToSuperview()
				make.top.bottom.lessThanOrEqualToSuperview()
				make.centerY.equalToSuperview()
			}
			
			textView.snp.remakeConstraints { (make) in
				make.leading.equalTo(leadingView.snp.trailing)
				make.trailing.equalToSuperview()
				make.top.bottom.equalToSuperview()
			}
			
			super.updateConstraints()
		}
		
		/// Updates ResponderNotifier publishers using the configuration.
		private func updatePublishers() {
			didBecomeFirstResponderPublisher = _configuration
				.textViewConfiguration
				.delegate.didBeginEditingPublisher
				.map { $0 as UIResponder }
				.eraseToAnyPublisher()
			didResignFirstResponderPublisher = _configuration
				.textViewConfiguration
				.delegate.didEndEditingPublisher
				.map { $0 as UIResponder }
				.eraseToAnyPublisher()
		}
		
		// MARK: - responder notifier
		
		private(set) lazy var didBecomeFirstResponderPublisher: AnyPublisher<UIResponder, Never> = _configuration
			.textViewConfiguration
			.delegate
			.didBeginEditingPublisher
			.map { $0 as UIResponder }
			.eraseToAnyPublisher()
		
		private(set) lazy var didResignFirstResponderPublisher: AnyPublisher<UIResponder, Never> = _configuration
			.textViewConfiguration
			.delegate
			.didEndEditingPublisher
			.map { $0 as UIResponder }
			.eraseToAnyPublisher()
		
		// -- responder passthrough
		
		override var isFirstResponder: Bool {
			textView.isFirstResponder
		}
		
		override var canBecomeFirstResponder: Bool {
			textView.canBecomeFirstResponder
		}
		
		override func becomeFirstResponder() -> Bool {
			super.becomeFirstResponder()
			return textView.becomeFirstResponder()
		}
		
		override var canResignFirstResponder: Bool {
			textView.canResignFirstResponder
		}
		
		override func resignFirstResponder() -> Bool {
			super.resignFirstResponder()
			return textView.resignFirstResponder()
		}
	}
}
