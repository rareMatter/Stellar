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
struct SearchBarContentConfiguration: SDynamicContentConfiguration {
	
    public var sizeDidChange: () -> Void = { debugPrint("Blank `sizeDidChange` handler called.") }
    
    public var placeholderText: String
    public var style: UISearchBar.Style

    public
    init(placeholderText: String, style: UISearchBar.Style = .minimal) {
        self.placeholderText = placeholderText
        self.style = style
    }
    
    private var searchBarDelegateConfiguration: SSearchBarDelegateConfiguration = .init()
    
    public func makeContentView() -> UIView & UIContentView {
		ContentView(configuration: self)
	}
	
    public func updated(for state: UIConfigurationState) -> SearchBarContentConfiguration {
		self
	}
}

// MARK: - api
public
extension SearchBarContentConfiguration {
    
    func onSearchTextChange(_ handler: @escaping (String) -> Void) -> Self {
        searchBarDelegateConfiguration.searchTextDidChangeHandler = { searchBar in
            sizeDidChange()
            handler(searchBar.text ?? "")
        }
        return self
    }
}

// MARK: - content view
private
extension SearchBarContentConfiguration {
	final
    class ContentView: UIView, UIContentView {
		
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
            searchBar.delegate = searchBarContentConfiguration.searchBarDelegateConfiguration
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
			left.searchBarDelegateConfiguration === right.searchBarDelegateConfiguration &&
			left.style == right.style
	}
    public func hash(into hasher: inout Hasher) {
		hasher.combine(placeholderText)
		hasher.combine(searchBarDelegateConfiguration.hash)
		hasher.combine(style)
	}
}
