//
//  SContentModifier+Rendering.swift
//  
//
//  Created by Jesse Spencer on 6/7/21.
//

import Foundation
import UIKit

extension SAccessoriesModifier: UIKitRenderableContentModifier {
    
    func applyTo(_ target: UIKitRenderableContent) {
        if let cellAccessories = self.accessories as? [UICellAccessory] {
            target.accessories = cellAccessories
        }
    }
}

extension SBackgroundContentModifier: UIKitRenderableContentModifier {
    
    func applyTo(_ target: UIKitRenderableContent) {
        var backgroundConfig = target.backgroundConfiguration
        
        backgroundConfig.backgroundColor = UIColor(self.backgroundColor)
        
        target.backgroundConfiguration = backgroundConfig
    }
}

extension SDisabledContentModifier: UIKitRenderableContentModifier {
    
    func applyTo(_ target: UIKitRenderableContent) {
        target.isDisabled = self.isDisabled
    }
}

extension SEditingSelectableContentModifier: UIKitRenderableContentModifier {
    
    func applyTo(_ target: UIKitRenderableContent) {
        target.isEditingSelectable = isSelectable
    }
}

extension STapHandlerModifier: UIKitRenderableContentModifier {
    
    func applyTo(_ target: UIKitRenderableContent) {
        target.tapHandler = .init(self.tapHandler)
    }
}
