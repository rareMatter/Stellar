//
//  UIConfigurationStateCustomKey+Properties.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

import UIKit

extension UIConfigurationStateCustomKey {
    static
    let isEditingSelectable = UIConfigurationStateCustomKey("me.rarematter.SContentCell.isEditingSelectable")
}

extension UICellConfigurationState {
    var isEditingSelectable: Bool {
        get { self[.isEditingSelectable] as? Bool ?? false }
        set { self[.isEditingSelectable] = newValue }
    }
}
