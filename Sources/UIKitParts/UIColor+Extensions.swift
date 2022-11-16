//
//  UIColor+Extensions.swift
//  
//
//  Created by Jesse Spencer on 9/14/21.
//

import UIKit
import StellarFoundation
import utilities

extension UIColor {
    
    static
    var allowedColorValueRange: ClosedRange<Double> {
        0...1
    }
}

extension UIColor {
    
    static
    func makeColor(_ anyColor: AnyColor) -> UIColor {
        // convert RGB values to UIColor RGB range [0, 1].
        let mappedRGBValues = [anyColor.red, anyColor.green, anyColor.blue]
            .map { rescale(value: $0, currentMax: anyColor.allowedColorRange.upperBound, newMax: UIColor.allowedColorValueRange.upperBound) }
        let red = CGFloat(mappedRGBValues[0])
        let green = CGFloat(mappedRGBValues[1])
        let blue = CGFloat(mappedRGBValues[2])
        let opacity = CGFloat(anyColor.opacity)
        
        switch anyColor.colorSpace {
        case .displayP3:
            return .init(displayP3Red: red, green: green, blue: blue, alpha: opacity)
        case .sRGB:
            return .init(red: red, green: green, blue: blue, alpha: opacity)
        }
    }
}
