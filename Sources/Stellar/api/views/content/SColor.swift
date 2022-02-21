//
//  SColor.swift
//  
//
//  Created by Jesse Spencer on 9/13/21.
//

import Foundation

#if canImport(UIKit)

import UIKit

public
typealias SColorData = (r: Double,
                        g: Double,
                        b: Double,
                        opacity: Double,
                        colorSpace: SColorSpace)

/** A representation of a color which can be used as a view.
 
 The type colors available are all created in the `sRGB` color space.
*/
public
struct SColor: SPrimitiveContent {
    
    static
    let allowedColorRange = ClosedRange<Double>(uncheckedBounds: (0, 255))
    static
    let allowedOpacityRange = ClosedRange<Double>(uncheckedBounds: (0, 1))
    
    let red: Double
    let green: Double
    let blue: Double
    
    let opacity: Double
    
    let colorSpace: SColorSpace
    
    /**
     Creates a color using the RGB color model in the specified color space.
     
     RGB values must be within the inclusive range of [0, 255]. Opacity must be within the inclusive range of [0,1]. Values outside of the ranges will be clamped to the nearest possible value.
     
     - parameter colorSpace: The color space in which to create the color using the given values. In other words, the provided color values should be chosen *in* the specified color space, otherwise an unexpected conversion may change the perceived color.
    */
    public
    init(red: Double, green: Double, blue: Double, opacity: Double = 1, colorSpace: SColorSpace = .sRGB) {
        self.red = red.clamp(to: SColor.allowedColorRange)
        self.green = green.clamp(to: SColor.allowedColorRange)
        self.blue = blue.clamp(to: SColor.allowedColorRange)
        self.opacity = opacity.clamp(to: SColor.allowedOpacityRange)
        self.colorSpace = colorSpace
    }
}
public
extension SColor {
    
    static
    var black: SColor {
        .init(red: 0, green: 0, blue: 0)
    }
    
    static
    var white: SColor {
        .init(red: 255, green: 255, blue: 255)
    }
    
    static
    var blue: SColor {
        .init(red: 13, green: 121, blue: 242)
    }
    
    static
    var green: SColor {
        .init(red: 67, green: 242, blue: 13)
    }
    
    static
    var orange: SColor {
        .init(red: 242, green: 175, blue: 13)
    }
    
    static
    var purple: SColor {
        .init(red: 147, green: 13, blue: 242)
    }
    
    static
    var yellow: SColor {
        .init(red: 229, green: 242, blue: 13)
    }
}

#endif

public
enum SColorSpace {
    case displayP3,
         sRGB
}
