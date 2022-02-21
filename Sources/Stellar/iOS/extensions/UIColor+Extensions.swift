//
//  UIColor+Extensions.swift
//  
//
//  Created by Jesse Spencer on 9/14/21.
//

import UIKit

extension UIColor {
    
    static
    var allowedColorValueRange: ClosedRange<Double> {
        0...1
    }
}

extension UIColor {
    
    static
    func makeColor(r: Double, g: Double, b: Double, opacity: Double, colorSpace: SColorSpace) -> UIColor {
        // convert RGB values to UIColor RGB range [0, 1].
        let mappedRGBValues = [r, g, b]
            .map { rescale(value: $0, currentMax: SColor.allowedColorRange.upperBound, newMax: UIColor.allowedColorValueRange.upperBound) }
        let red = CGFloat(mappedRGBValues[0])
        let green = CGFloat(mappedRGBValues[1])
        let blue = CGFloat(mappedRGBValues[2])
        let opacity = CGFloat(opacity)
        
        switch colorSpace {
        case .displayP3:
            return .init(displayP3Red: red, green: green, blue: blue, alpha: opacity)
        case .sRGB:
            return .init(red: red, green: green, blue: blue, alpha: opacity)
        }
    }
}
