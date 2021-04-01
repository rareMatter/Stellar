//
//  ContextMenuButtonContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/22/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// Displays a button which shows a contexual menu containing provided actions.
public
struct ContextMenuButtonContentConfiguration: SContentConfiguration, Equatable {
	
	var title: String
	var titleProperties: TextProperties

	var menu: UIMenu?
	var menuWillAppear: ContextMenuButton.MenuTransitionHandler
	var menuWillDisappear: ContextMenuButton.MenuTransitionHandler
    
    public init(title: String, titleProperties: TextProperties = .init(font: .preferredFont(forTextStyle: .title1)), menu: UIMenu? = nil, menuWillAppear: @escaping ContextMenuButton.MenuTransitionHandler = {_,_,_ in}, menuWillDisappear: @escaping ContextMenuButton.MenuTransitionHandler = {_,_,_ in}) {
        self.title = title
        self.titleProperties = titleProperties
        self.menu = menu
        self.menuWillAppear = menuWillAppear
        self.menuWillDisappear = menuWillDisappear
    }
    
    public func makeContentView() -> UIView & UIContentView {
		ContentView(contextMenuButtonContentConfiguration: self)
	}
	
    public func updated(for state: UIConfigurationState) -> ContextMenuButtonContentConfiguration {
		self
	}
	
	// MARK: equatable
    public static func == (lhs: ContextMenuButtonContentConfiguration, rhs: ContextMenuButtonContentConfiguration) -> Bool {
		lhs.title == rhs.title &&
			lhs.titleProperties == rhs.titleProperties &&
			lhs.menu == rhs.menu
	}
}
// MARK: - content view
extension ContextMenuButtonContentConfiguration {
	private final class ContentView: UIView, UIContentView {
		// -- config
		var configuration: UIContentConfiguration {
			get { _configuration }
			set {
				guard let newConfig = newValue as? ContextMenuButtonContentConfiguration else {
					assertionFailure("Expected \(ContextMenuButtonContentConfiguration.self).")
					return
				}
				guard newConfig != _configuration else { return }
				_configuration = newConfig
			}
		}
		private var _configuration: ContextMenuButtonContentConfiguration {
			didSet {
				updateForConfiguration()
			}
		}
		
		// -- views
		private let button: ContextMenuButton = {
			let button = ContextMenuButton(frame: .zero)
			button.setTitleColor(.label, for: .normal)
			button.contentHorizontalAlignment = .leading
			button.translatesAutoresizingMaskIntoConstraints = false
			return button
		}()
		
		// MARK: - init
		
		init(contextMenuButtonContentConfiguration: ContextMenuButtonContentConfiguration) {
			self._configuration = contextMenuButtonContentConfiguration
			
			super.init(frame: .zero)
		
			addSubview(button)
			button.snp.makeConstraints { (make) in
				make.directionalEdges.equalToSuperview()
				make.top.bottom.equalToSuperview()
			}
			
			updateForConfiguration()
		}
		
		@available(*, unavailable)
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		// MARK: - view lifecycle
		
		private func updateForConfiguration() {
			button.setTitle(_configuration.title, for: .normal)
			button.titleLabel?.font = _configuration.titleProperties.font
			button.menu = _configuration.menu
		}
	}
}
