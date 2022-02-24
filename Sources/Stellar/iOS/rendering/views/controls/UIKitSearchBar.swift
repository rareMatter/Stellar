//
//  UISearchBar.swift
//  
//
//  Created by Jesse Spencer on 2/24/22.
//

import Foundation
import UIKit

final
class UIKitSearchBar: _UIKitSearchTextField, UIKitTargetRenderableContent {
    
    init(primitive: UIKitSearchBarPrimitive) {
        super.init(frame: .zero)
        update(with: primitive)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with primitive: AnyUIKitPrimitive) {
        guard let searchPrimitive = primitive as? UIKitSearchBarPrimitive else { return }
        self.text = searchPrimitive.text
        self.placeholder = searchPrimitive.placeholderText
        self.textDidChange = searchPrimitive.onSearch.t
        self.onReturn = { _ in searchPrimitive.onSearchEnded.t() }
    }
}
