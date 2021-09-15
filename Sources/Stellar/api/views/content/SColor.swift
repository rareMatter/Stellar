//
//  SColor.swift
//  
//
//  Created by Jesse Spencer on 9/13/21.
//

import Foundation

#if canImport(UIKit)

import UIKit

/// A representation of a color which can be used as a view.
public
struct SColor: SPrimitiveContent {
    
    static
    let allowedHueRange = ClosedRange<Double>(uncheckedBounds: (0, 359))
    /// The allowed closed range for HSL and opacity parameter values.
    static
    let allowedGeneralClosedRange = ClosedRange<Double>(uncheckedBounds: (0, 1))
    
    let hue: Double
    let saturation: Double
    let lightness: Double
    let opacity: Double
    
    public
    init(hue: Double, saturation: Double, lightness: Double, opacity: Double = 1) {
        self.hue = hue.clamp(to: SColor.allowedHueRange)
        self.saturation = saturation.clamp(to: SColor.allowedGeneralClosedRange)
        self.lightness = lightness.clamp(to: SColor.allowedGeneralClosedRange)
        self.opacity = opacity.clamp(to: SColor.allowedGeneralClosedRange)
    }
}
public
extension SColor {
    
    static
    var black: SColor {
        .init(hue: 359, saturation: 1, lightness: 0)
    }
    
    static
    var white: SColor {
        .init(hue: 359, saturation: 1, lightness: 1)
    }
    
    static
    var blue: SColor {
        .init(hue: 233, saturation: 0.9, lightness: 0.5)
    }
    
    static
    var green: SColor {
        .init(hue: 106, saturation: 0.9, lightness: 0.5)
    }
    
    static
    var orange: SColor {
        .init(hue: 42, saturation: 0.9, lightness: 0.5)
    }
    
    static
    var purple: SColor {
        .init(hue: 275, saturation: 0.9, lightness: 0.5)
    }
    
    static
    var yellow: SColor {
        .init(hue: 64, saturation: 0.9, lightness: 0.5)
    }
}

#endif
