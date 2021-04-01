//
//  SearchBarContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/14/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// An interactive search bar.
public
struct SearchBarContentConfiguration: SDynamicContentConfiguration {
	
    public var sizeDidChange: () -> Void = { debugPrint("Blank `sizeDidChange` handler called.") } {
        didSet {
            // update delegate
            searchBarDelegateConfiguration.onTextChange = { [onSearch, sizeDidChange] searchBar in
                sizeDidChange()
                onSearch(searchBar.text ?? "")
            }
        }
    }
    
    public var placeholderText: String
    public var style: UISearchBar.Style

    // search bar delegate
    private var searchBarDelegateConfiguration: SSearchBarDelegate = .init()
    
    // search handlers
    private
    let onSearch: (String) -> Void
    private
    let onSearchEnded: () -> Void
    
    public
    init(placeholderText: String = "Search...", style: UISearchBar.Style = .minimal, onSearch: @escaping (String) -> Void, onSearchEnded: @escaping () -> Void) {
        self.placeholderText = placeholderText
        self.style = style
        self.onSearch = onSearch
        self.onSearchEnded = onSearchEnded
        
        // prepare search bar delegate
        searchBarDelegateConfiguration.didBeginEditing = { searchBar in
            searchBar.setShowsCancelButton(true, animated: true)
            onSearch(searchBar.text ?? "")
        }
        searchBarDelegateConfiguration.onTextChange = { [sizeDidChange] searchBar in
            sizeDidChange()
            onSearch(searchBar.text ?? "")
        }
        searchBarDelegateConfiguration.onSearchClicked = { searchBar in
            searchBar.endEditing(true)
        }
        searchBarDelegateConfiguration.didEndEditing = { searchBar in
            searchBar.setShowsCancelButton(false, animated: true)
            onSearch(searchBar.searchTextField.text ?? "")
        }
        searchBarDelegateConfiguration.onCancel = { searchBar in
            searchBar.searchTextField.text = nil
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.endEditing(true)
            onSearchEnded()
        }
    }
    
    public func makeContentView() -> UIView & UIContentView {
		ContentView(configuration: self)
	}
	
    public func updated(for state: UIConfigurationState) -> SearchBarContentConfiguration {
		self
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
