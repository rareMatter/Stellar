//
//  STextEditor.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct STextEditor: SPrimitiveContent {
    
    @SBinding var text: String
    let placeholderText: String
    
    let onTextChange: (String) -> Void
    var inputAccessoryView: UIView?
}

public
extension STextEditor {
    
    init(text: SBinding<String>,
         placeholderText: String = "",
         onTextChange: @escaping (String) -> Void) {
        self._text = text
        self.placeholderText = placeholderText
        self.onTextChange = onTextChange
    }
}

// MARK: - modifiers
public
extension STextEditor {
    
    func inputAccessory(_ view: UIView?) -> Self {
        var modified = self
        modified.inputAccessoryView = view
        return modified
    }
}
