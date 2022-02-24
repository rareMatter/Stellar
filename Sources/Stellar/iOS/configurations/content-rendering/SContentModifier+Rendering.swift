//
//  SContentModifier+Rendering.swift
//  
//
//  Created by Jesse Spencer on 6/7/21.
//

import Foundation
import UIKit

extension SDisabledContentModifier: UIKitRenderableContentModifier {
    
    func applyTo(_ target: UIKitRenderableContent) {
        target.isDisabled = self.isDisabled
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
