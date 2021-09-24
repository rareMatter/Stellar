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

extension SColorBackgroundContentModifier: UIKitRenderableContentModifier {
    
    func applyTo(_ target: UIKitRenderableContent) {
        var backgroundConfig = target.backgroundConfiguration
        
        backgroundConfig.backgroundColor = UIColor(sColor: backgroundColor)
        
        target.backgroundConfiguration = backgroundConfig
    }
}

extension SDynamicColorBackgroundContentModifier: UIKitRenderableContentModifier {
    
    func applyTo(_ target: UIKitRenderableContent) {
        var backgroundConfig = target.backgroundConfiguration
        
        backgroundConfig.backgroundColor = UIColor(sDynamicColor: backgroundDynamicColor)
        
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

extension SCornerRadiusModifier: UIKitRenderableContentModifier {
    
    func applyTo(_ target: UIKitRenderableContent) {
        var backgroundConfig = target.backgroundConfiguration
        
        backgroundConfig.cornerRadius = cornerRadius
        
        target.backgroundConfiguration = backgroundConfig
    }
}
