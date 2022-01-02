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
        // convert SColor RGB values to UIColor RGB range [0, 1].
        let mappedRGBValues = [sColor.red, sColor.green, sColor.blue]
            .map { colorValue in
                (1/SColor.allowedColorRange.upperBound) * colorValue
            }
        let red = CGFloat(mappedRGBValues[0])
        let green = CGFloat(mappedRGBValues[1])
        let blue = CGFloat(mappedRGBValues[2])
        let opacity = CGFloat(sColor.opacity)
        
        switch sColor.colorSpace {
            case .displayP3:
                self.init(displayP3Red: red, green: green, blue: blue, alpha: opacity)
            case .sRGB:
                self.init(red: red, green: green, blue: blue, alpha: opacity)
        }
    }
    
    public
    convenience
    init(sDynamicColor: SDynamicColor) {
        let currentColorScheme: ColorScheme = STraitCollection
            .currentUITraitCollection
            .userInterfaceStyle == .dark ? .dark : .light
        let resolvedColor = sDynamicColor.resolvedColor(with: currentColorScheme)
        
        self.init(sColor: SColor(red: resolvedColor.r,
                                 green: resolvedColor.g,
                                 blue: resolvedColor.b,
                                 opacity: resolvedColor.opacity))
    }
}
