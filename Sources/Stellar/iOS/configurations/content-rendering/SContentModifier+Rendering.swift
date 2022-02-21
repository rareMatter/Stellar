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
        
        backgroundConfig.backgroundColor = .makeColor(r: backgroundColor.red,
                                                      g: backgroundColor.green,
                                                      b: backgroundColor.blue,
                                                      opacity: backgroundColor.opacity,
                                                      colorSpace: backgroundColor.colorSpace)
        
        target.backgroundConfiguration = backgroundConfig
    }
}

extension SDynamicColorBackgroundContentModifier: UIKitRenderableContentModifier {
    
    @available(*, deprecated)
    func applyTo(_ target: UIKitRenderableContent) {
        var backgroundConfig = target.backgroundConfiguration
        
        let currentColorScheme: ColorScheme = STraitCollection
            .currentUITraitCollection
            .userInterfaceStyle == .dark ? .dark : .light
        let resolvedColor = backgroundDynamicColor.resolvedColor(with: currentColorScheme)
        
        backgroundConfig.backgroundColor = .makeColor(r: resolvedColor.r,
                                                      g: resolvedColor.g,
                                                      b: resolvedColor.b,
                                                      opacity: resolvedColor.opacity,
                                                      colorSpace: resolvedColor.colorSpace)
        
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
