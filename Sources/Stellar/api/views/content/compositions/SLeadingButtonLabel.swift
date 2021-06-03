//
//  SLeadingButtonLabel.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SLeadingButtonLabel: SPrimitiveContent {
    
    var text: String = ""
    
    var actionHandler: () -> Void = {}
    
    var buttonImage: UIImage
    var buttonBackgroundColor: UIColor?
    
    var accessories = [UICellAccessory]()
    
    var backgroundColor: UIColor?
    
    var isSelected = false
    var isDisabled = false
    
    public
    init(title: String,
         buttonImage: UIImage,
         buttonBackgroundColor: UIColor? = nil,
         action: @escaping () -> Void) {
        self.text = title
        self.buttonImage = buttonImage
        self.buttonBackgroundColor = buttonBackgroundColor
        self.actionHandler = action
    }
}

// MARK: - modifiers
public
extension SLeadingButtonLabel {
    
    func selected(_ state: Bool) -> Self {
        var modified = self
        modified.isSelected = state
        return modified
    }
    
    func background(_ color: UIColor) -> Self {
        var modified = self
        modified.backgroundColor = color
        return modified
    }
    
    func disabled(_ state: Bool) -> Self {
        var modified = self
        modified.isDisabled = state
        return modified
    }
    
    func accessories(_ accessories: [UICellAccessory]) -> Self {
        var modified = self
        modified.accessories = accessories
        return modified
    }
}
