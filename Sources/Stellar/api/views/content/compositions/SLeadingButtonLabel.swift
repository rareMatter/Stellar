//
//  SLeadingButtonLabel.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

@available(*, deprecated, message: "Create compositions using primitive content types instead.")
public
struct SLeadingButtonLabel: SPrimitiveContent {
    
    var text: String
    
    var buttonImage: UIImage
    var buttonBackgroundColor: UIColor?
    
    var actionHandler: () -> Void
    
    public
    init(text: String,
         buttonImage: UIImage,
         buttonBackgroundColor: UIColor? = nil,
         action: @escaping () -> Void) {
        self.text = text
        self.buttonImage = buttonImage
        self.buttonBackgroundColor = buttonBackgroundColor
        self.actionHandler = action
    }
}
