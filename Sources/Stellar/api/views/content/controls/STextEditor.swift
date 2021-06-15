//
//  STextEditor.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct STextEditor: SPrimitiveContent {
    
    var text: String
    var placeholderText: String
    
    var onTextChange: (String) -> Void
    
    var inputAccessoryView: UIView?
    
    public
    init(text: String,
         placeholderText: String = "",
         onTextChange: @escaping (String) -> Void) {
        self.text = text
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
