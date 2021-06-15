//
//  SearchBarContentConfiguration.swift
//  Stellar
//
//  Created by Jesse Spencer on 10/14/20.
//  Copyright © 2020 Jesse Spencer. All rights reserved.
//

import UIKit

/// An interactive search bar.
struct SearchBarContentConfiguration: SContentConfiguration, Hashable {
    
    var text: String
    var placeholderText: String
    
    let onSearch: (String) -> Void
    let onSearchEnded: () -> Void
    
    var style: UISearchBar.Style
    
    var configurationState: UICellConfigurationState = .init(traitCollection: .current)
}

// MARK: hashable
extension SearchBarContentConfiguration {
    
    static
    func ==(_ left: SearchBarContentConfiguration, _ right: SearchBarContentConfiguration) -> Bool {
        left.placeholderText == right.placeholderText &&
            left.style == right.style
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(placeholderText)
        hasher.combine(style)
    }
}

// MARK: - content view
extension SearchBarContentConfiguration {
    
    func contentView() -> _SContentView<Self> {
        
        let searchBar: SSearchBarView = {
            let searchBar = SSearchBarView()
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            
            // search bar interactions
            searchBar.didBeginEditing = { searchBar in
                searchBar.setShowsCancelButton(true, animated: true)
                self.onSearch(searchBar.text ?? "")
            }
            searchBar.onTextChange = { searchBar in
                self.onSearch(searchBar.text ?? "")
            }
            searchBar.onSearchClicked = { searchBar in
                searchBar.endEditing(true)
            }
            searchBar.didEndEditing = { searchBar in
                searchBar.setShowsCancelButton(false, animated: true)
                self.onSearch(searchBar.searchTextField.text ?? "")
            }
            searchBar.onCancel = { searchBar in
                searchBar.searchTextField.text = nil
                searchBar.setShowsCancelButton(false, animated: true)
                searchBar.endEditing(true)
                self.onSearchEnded()
            }
            
            return searchBar
        }()
        
        return _SContentView<Self>(configuration: self, responder: searchBar) { contentView in
            contentView.addSubview(searchBar)
        } handleConstraintUpdate: { contentView, isFirstSetup in
            guard isFirstSetup else { return }
            searchBar.snp.makeConstraints { (make) in
                make.directionalEdges.equalTo(contentView.snp.directionalMargins)
                make.top.equalTo(contentView.snp.topMargin)
                make.bottom.equalTo(contentView.snp.bottomMargin)
            }
        } handleConfigurationUpdate: { oldConfig, updatedConfig, contentView in
            searchBar.searchBarStyle = updatedConfig.style
            searchBar.placeholder = updatedConfig.placeholderText
        }
    }
}

// MARK: SPrimitiveRepresentable
extension SSearchBar: UIKitContentRenderer {
    
    func mountContent(on target: UIKitRenderableContent) {
        target.contentConfiguration = 
            SearchBarContentConfiguration(text: text,
                                          placeholderText: placeholderText,
                                          onSearch: onSearch,
                                          onSearchEnded: onSearchEnded,
                                          style: style)
    }
}
