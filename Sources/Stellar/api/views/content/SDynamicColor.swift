//
//  SDynamicColor.swift
//  
//
//  Created by Jesse Spencer on 9/14/21.
//

import Foundation

#if canImport(UIKit)

import UIKit

/// A color which, when created, allows you to dynamically respond to changes in the environment to adapt the actual color.
public
struct SDynamicColor: SPrimitiveContent {
    public
    typealias ColorResolver = (ColorScheme) -> SColor
    
    private
    let colorResolver: ColorResolver
    
    /// Creates a color which adapts to the current environment.
    public
    init(colorResolver: @escaping ColorResolver) {
        self.colorResolver = colorResolver
    }
}
extension SDynamicColor {
    func resolvedColor(with colorScheme: ColorScheme) -> SColor {
        colorResolver(colorScheme)
    }
}

public
enum ColorScheme {
    case light
    case dark
}

#endif
