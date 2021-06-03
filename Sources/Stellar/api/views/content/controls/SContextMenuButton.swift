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
    
    var menuItems: [UIMenuElement]
    
    var isDisabled = false
    
    public
    init(title: String,
         image: UIImage? = nil,
         menuItems: [UIMenuElement]) {
        self.title = title
        self.image = image
        self.menuItems = menuItems
    }
    
    public
    init(image: UIImage,
         menuItems: [UIMenuElement]) {
        self.init(title: "",
                  image: image,
                  menuItems: menuItems)
    }
}

// MARK: - modifiers
public
extension SContextMenuButton {
    
    func disabled(_ state: Bool) -> Self {
        var modified = self
        modified.isDisabled = state
        return modified
    }
}
