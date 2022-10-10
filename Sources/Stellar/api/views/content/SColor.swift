//
//  SColor.swift
//  
//
//  Created by Jesse Spencer on 9/13/21.
//

import Foundation

/** A representation of a color which can be used as a view.
 
 The standard colors are all created in the `sRGB` color space.
*/
public
struct SColor: SContent {
    
    private
    enum ResolvedColor {
        case primitive(PrimitiveColor)
        case dynamic(DynamicColor)
    }
    
    private
    let resolvedColor: ResolvedColor
    
    /**
     Creates a color using the RGB color model in the specified color space.
     
     RGB values must be within the inclusive range of [0, 255]. Opacity must be within the inclusive range of [0,1]. Values outside of the ranges will be clamped to the nearest possible value.
     
     - parameter colorSpace: The color space in which to create the color using the given values. In other words, the provided color values should be chosen *in* the specified color space, otherwise an unexpected conversion may change the perceived color.
    */
    public
    init(red: Double, green: Double, blue: Double, opacity: Double = 1, colorSpace: SColorSpace = .sRGB) {
        resolvedColor = .primitive(.init(red: red, green: green, blue: blue, opacity: opacity, colorSpace: colorSpace))
    }
    
    public
    init(colorSpace: SColorSpace = .sRGB, _ resolveColor: @escaping (ColorScheme) -> PrimitiveColor) {
        resolvedColor = .dynamic(.init(colorSpace: colorSpace, resolveColor))
    }
    
    public
    var body: some SContent {
        switch resolvedColor {
        case .primitive(let primitiveColor):
            primitiveColor
        case .dynamic(let dynamicColor):
            dynamicColor
        }
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

public
enum SColorSpace {
    case displayP3,
         sRGB
}

public enum ColorScheme {
    case dark, light
}

struct DynamicColor: SContent {
    // TODO: Need color scheme from environment.
    
    private
    let colorSpace: SColorSpace
    
    private
    let resolveColor: (ColorScheme) -> PrimitiveColor
    
    init(colorSpace: SColorSpace, _ resolveColor: @escaping (ColorScheme) -> PrimitiveColor) {
        self.resolveColor = resolveColor
        self.colorSpace = colorSpace
    }
    
    var body: some SContent {
        // TODO: Provide environment property.
        resolveColor(.light)
    }
}

/// You do not need to use this type directly, instead create colors using `SColor`.
///
/// The framework creates this type when needed on your behalf.
public
struct PrimitiveColor: SPrimitiveContent {
    
    static
    let allowedColorRange = ClosedRange<Double>(uncheckedBounds: (0, 255))
    static
    let allowedOpacityRange = ClosedRange<Double>(uncheckedBounds: (0, 1))
    
    // FIXME: temp public
    public
    let red: Double
    public
    let green: Double
    public
    let blue: Double
    
    public
    let opacity: Double
    
    public
    let colorSpace: SColorSpace
    
    /**
     Creates a color using the RGB color model in the specified color space.
     
     RGB values must be within the inclusive range of [0, 255]. Opacity must be within the inclusive range of [0,1]. Values outside of the ranges will be clamped to the nearest possible value.
     
     - parameter colorSpace: The color space in which to create the color using the given values. In other words, the provided color values should be chosen *in* the specified color space, otherwise an unexpected conversion may change the perceived color.
     */
    internal
    init(red: Double, green: Double, blue: Double, opacity: Double = 1, colorSpace: SColorSpace = .sRGB) {
        self.red = red.clamp(to: Self.allowedColorRange)
        self.green = green.clamp(to: Self.allowedColorRange)
        self.blue = blue.clamp(to: Self.allowedColorRange)
        self.opacity = opacity.clamp(to: Self.allowedOpacityRange)
        self.colorSpace = colorSpace
    }
}
extension PrimitiveColor: AnyColor {}

// FIXME: temp public
public
protocol AnyColor {
    var red: Double { get }
    var green: Double { get }
    var blue: Double { get }
    
    var opacity: Double { get }
    
    var colorSpace: SColorSpace { get }
}
extension AnyColor {
    var allowedColorRange: ClosedRange<Double> { PrimitiveColor.allowedColorRange }
    var allowedOpacityRange: ClosedRange<Double> { PrimitiveColor.allowedOpacityRange }
}
