//
//  SLeadingViewTextEditor.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit
import StellarFoundation

@available(*, deprecated, message: "Create compositions using primitive content types instead.")
public
struct SLeadingViewTextEditor: SPrimitiveContent {
    
    var text: String
    var placeholderText: String

    var leadingView: UIView
    
    var textChangeHandler: (String) -> Void
    
    var inputAccessoryView: UIView?
    
    public
    init(text: String,
         placeholderText: String = "",
         leadingView: UIView,
         textChangeAction: @escaping (String) -> Void) {
        self.text = text
        self.placeholderText = placeholderText
        self.leadingView = leadingView
        self.textChangeHandler = textChangeAction
    }
}

// MARK: - modifiers
public
extension SLeadingViewTextEditor {
    
    func inputAccessory(_ view: UIView?) -> Self {
        var modified = self
        modified.inputAccessoryView = view
        return modified
    }
}
