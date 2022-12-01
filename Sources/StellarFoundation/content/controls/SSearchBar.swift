//
//  SSearchBar.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

public
struct SSearchBar: SPrimitiveContent {
    @SBinding public var text: String
    public let placeholderText: String
    public let onSearch: (String) -> Void
    public let onSearchEnded: () -> Void
    
    public
    init(text: SBinding<String>, placeholderText: String = "", onSearch: @escaping (String) -> Void, onSearchEnded: @escaping () -> Void) {
        self._text = text
        self.placeholderText = placeholderText
        self.onSearch = onSearch
        self.onSearchEnded = onSearchEnded
    }
}
