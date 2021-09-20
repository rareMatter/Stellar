//
//  SContextMenuButton.swift
//  
//
//  Created by Jesse Spencer on 5/11/21.
//

import UIKit

public
struct SContextMenuButton: SPrimitiveContent {
    
    var title: String
    var image: UIImage?
    
    var backgroundColor: UIColor?
    
    var menuItems: [UIMenuElement]
    
    public
    init(title: String,
         backgroundColor: UIColor?,
         menuItems: [UIMenuElement]) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.menuItems = menuItems
    }
    
    public
    init(image: UIImage,
         backgroundColor: UIColor? = nil,
         menuItems: [UIMenuElement]) {
        self.init(title: "",
                  backgroundColor: backgroundColor,
                  menuItems: menuItems)
        self.image = image
    }
}
