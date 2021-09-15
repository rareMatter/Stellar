//
//  UIColor+Extensions.swift
//  
//
//  Created by Jesse Spencer on 9/14/21.
//

import UIKit

extension UIColor {
    
    public
    convenience
    init(sColor: SColor) {
        // convert SColor hue range [0, 359] to UIColor hue range [0, 1].
        let mappedHue = ((1/359) * sColor.hue)
        
        self.init(hue: CGFloat(mappedHue), saturation: CGFloat(sColor.saturation), brightness: CGFloat(sColor.lightness), alpha: CGFloat(sColor.opacity))
    }
    
    convenience
    init(sDynamicColor: SDynamicColor) {
        let currentColorScheme: ColorScheme = STraitCollection
            .currentUITraitCollection
            .userInterfaceStyle == .dark ? .dark : .light
        let resolvedColor = sDynamicColor.resolvedColor(with: currentColorScheme)
        
        self.init(sColor: resolvedColor)
    }
}
