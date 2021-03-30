//
//  NLColors.swift
//  Stellar
//
//  Created by Jesse Spencer on 2/9/21.
//  Copyright © 2021 Jesse Spencer. All rights reserved.
//

import Foundation

/// A description of a color as RGB values.
public struct NLColor: Codable {
    /// From 0.0 - 1.0
    var red: Double
    /// From 0.0 - 1.0
    var green: Double
    /// From 0.0 - 1.0
    var blue: Double
    /// From 0.0 - 1.0
    var alpha: Double = 1
}
// MARK: - standard colors
extension NLColor {
    static var blue: NLColor {
        .init(red: 0, green: 0, blue: 1)
    }
}
// MARK: - convenience methods
extension NLColor {
    /// Returns self with the new alpha value applied.
    func withAlpha(_ value: Double) -> Self {
        .init(red: self.red, green: self.green, blue: self.blue, alpha: value)
    }
}
// MARK: UIColor-NLColor mapping
public
extension NLColor {
    static func fromUIColor(_ uiColor: UIColor) -> NLColor {
        .init(uiColor: uiColor)
    }
    
    var asUIColor: UIColor {
        UIColor.fromNLColor(self)
    }
    
    private
    init(uiColor: UIColor) {
        self.init(red: uiColor.redValue.asDouble,
                  green: uiColor.greenValue.asDouble,
                  blue: uiColor.blueValue.asDouble,
                  alpha: uiColor.alphaValue.asDouble)
    }
}
import UIKit
public
extension UIColor {
    static func fromNLColor(_ nlColor: NLColor) -> UIColor {
        self.init(red: CGFloat(nlColor.red), green: CGFloat(nlColor.green), blue: CGFloat(nlColor.blue), alpha: CGFloat(nlColor.alpha))
    }
    
    var redValue: CGFloat { CIColor(color: self).red }
    var greenValue: CGFloat { CIColor(color: self).green }
    var blueValue: CGFloat { CIColor(color: self).blue }
    var alphaValue: CGFloat { CIColor(color: self).alpha }
}
