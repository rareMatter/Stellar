//
//  SSearchBar.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SSearchBar: SPrimitiveContent {
    
    var text: String
    var placeholderText: String
    
    var onSearch: (String) -> Void
    var onSearchEnded: () -> Void
    
    var style: UISearchBar.Style = .default
    
    public
    init(text: String,
         placeholderText: String = "Search...",
         onSearch: @escaping (String) -> Void,
         onSearchEnded: @escaping () -> Void = {}) {
        self.text = text
        self.placeholderText = placeholderText
        self.onSearch = onSearch
        self.onSearchEnded = onSearchEnded
    }
}

// MARK: - style
public
extension SSearchBar {
    
    func style(_ value: UISearchBar.Style) -> Self {
        var modified = self
        modified.style = value
        return modified
    }
}
