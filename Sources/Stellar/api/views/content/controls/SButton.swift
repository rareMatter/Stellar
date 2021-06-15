//
//  SButton.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SButton: SPrimitiveContent {
    
    var title: String
    var image: UIImage?
    
    var actionHandler: () -> Void
    
    var backgroundColor: UIColor?
    
    public
    init(title: String,
         backgroundColor: UIColor?,
         action: @escaping () -> Void) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.actionHandler = action
    }
    
    public
    init(image: UIImage,
         backgroundColor: UIColor? = nil,
         action: @escaping () -> Void) {
        self.init(title: "",
                  backgroundColor: backgroundColor,
                  action: action)
        self.image = image
    }
}
