//
//  SearchBar.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SSearchBar: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitSearchBarPrimitive(text: text,
                                      placeholderText: placeholderText,
                                      onSearch: .init(onSearch),
                                      onSearchEnded: .init(onSearchEnded)))
    }
}
struct UIKitSearchBarPrimitive: SContent, AnyUIKitPrimitive {
    let text: String
    let placeholderText: String
    
    let onSearch: SIdentifiableContainer<(String) -> Void>
    let onSearchEnded: SIdentifiableContainer<() -> Void>
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitSearchBar(primitive: self)
    }
}
