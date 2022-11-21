//
//  SSearchBar.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

public
struct SSearchBar: SPrimitiveContent {
    @SBinding var text: String
    let placeholderText: String
    let onSearch: (String) -> Void
    let onSearchEnded: () -> Void
    
    public
    init(text: SBinding<String>, placeholderText: String = "", onSearch: @escaping (String) -> Void, onSearchEnded: @escaping () -> Void) {
        self._text = text
        self.placeholderText = placeholderText
        self.onSearch = onSearch
        self.onSearchEnded = onSearchEnded
    }
}
