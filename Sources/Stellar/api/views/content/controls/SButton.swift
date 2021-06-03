//
//  SButton.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SButton: SPrimitiveContent {
    
    var actionHandler: () -> Void
    
    var title: String
    var image: UIImage?
    
    var backgroundColor: UIColor?
    
    var isSelected = false
    var isDisabled = false
    
    public
    init(title: String,
         backgroundColor: UIColor? = nil,
         action: @escaping () -> Void) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.actionHandler = action
    }
    
    public
    init(image: UIImage,
         action: @escaping () -> Void) {
        self.init(title: "", action: action)
    }
}

// MARK: - modifiers
public
extension SButton {
    
    func selected(_ state: Bool) -> Self {
        var modified = self
        modified.isSelected = state
        return modified
    }
    
    func disabled(_ state: Bool) -> Self {
        var modified = self
        modified.isDisabled = state
        return modified
    }
}
