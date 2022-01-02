//
//  SSearchBar.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SSearchBar: SPrimitiveContent {
    
    @SBinding var text: String
    let placeholderText: String
    
    var onSearch: (String) -> Void
    var onSearchEnded: () -> Void
    
    var style: UISearchBar.Style = .default
}

public
extension SSearchBar {

    init(text: SBinding<String>,
         placeholderText: String = "Search...",
         onSearch: @escaping (String) -> Void,
         onSearchEnded: @escaping () -> Void = {}) {
        self._text = text
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
