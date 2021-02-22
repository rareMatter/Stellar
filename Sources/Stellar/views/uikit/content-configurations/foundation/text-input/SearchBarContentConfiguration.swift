//
//  SearchBarContentConfiguration.swift
//  life-tool-1
//
//  Created by Jesse Spencer on 10/14/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// Displays an interactive search bar.
public
struct SearchBarContentConfiguration: UIContentConfiguration {
	
    public var placeholderText: String
    public var delegate: UISearchBarDelegate?
    public var style: UISearchBar.Style
	
    public
    init(placeholderText: String, delegate: UISearchBarDelegate? = nil, style: UISearchBar.Style = .minimal) {
        self.placeholderText = placeholderText
        self.delegate = delegate
        self.style = style
    }
    
    public func makeContentView() -> UIView & UIContentView {
		ContentView(configuration: self)
	}
	
    public func updated(for state: UIConfigurationState) -> SearchBarContentConfiguration {
		self
	}
}
private extension SearchBarContentConfiguration {
	final class ContentView: UIView, UIContentView {
		
		// -- configuration
		
		var configuration: UIContentConfiguration {
			get { searchBarContentConfiguration }
			set {
				guard let newConfig = newValue as? SearchBarContentConfiguration else {
					assertionFailure("Expected instance of SearchBarContentConfiguration, got \(newValue.self).")
					return
				}
				guard newConfig != searchBarContentConfiguration else {
					return
				}
				searchBarContentConfiguration = newConfig
			}
		}
		
		private var searchBarContentConfiguration: SearchBarContentConfiguration {
			didSet {
				updateViewState()
			}
		}
		
		// -- views
		private let searchBar: UISearchBar = {
			let searchBar = UISearchBar(frame: .zero)
			searchBar.translatesAutoresizingMaskIntoConstraints = false
			return searchBar
		}()
		
		init(configuration: SearchBarContentConfiguration) {
			self.searchBarContentConfiguration = configuration
			super.init(frame: .zero)
			addSubview(searchBar)
			setNeedsUpdateConstraints()
		}
		
		@available(*, unavailable)
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		// -- view lifecycle
		
		private func updateViewState() {
			searchBar.delegate = searchBarContentConfiguration.delegate
			searchBar.searchBarStyle = searchBarContentConfiguration.style
			searchBar.placeholder = searchBarContentConfiguration.placeholderText
		}
		
		private var needsConstraintsSetup = true
		override func updateConstraints() {
			if needsConstraintsSetup {
				searchBar.snp.makeConstraints { (make) in
					make.directionalEdges.equalToSuperview()
				}
				needsConstraintsSetup = false
			}
			
			super.updateConstraints()
		}
	}
}
// MARK: hashable
extension SearchBarContentConfiguration: Hashable {
    public static func ==(_ left: SearchBarContentConfiguration, _ right: SearchBarContentConfiguration) -> Bool {
		left.placeholderText == right.placeholderText &&
			left.delegate === right.delegate &&
			left.style == right.style
	}
    public func hash(into hasher: inout Hasher) {
		hasher.combine(placeholderText)
		hasher.combine(delegate?.hash)
		hasher.combine(style)
	}
}
