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
struct SColor: SPrimitiveContent {
    let hue: Double
    let saturation: Double
    let brightness: Double
    let opacity: Double
    
    public
    init(hue: Double, saturation: Double, brightness: Double, opacity: Double) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.opacity = opacity
    }
}

enum SColorSpace: Hashable {
    case sRGB
    case sRGBLinear
    case displayP3
}

#endif
