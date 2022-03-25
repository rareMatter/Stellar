//
//  Color.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SColor: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitColorPrimitive(red: red,
                                  green: green,
                                  blue: blue,
                                  opacity: opacity,
                                  colorSpace: colorSpace))
    }
}
struct UIKitColorPrimitive: SContent, AnyUIKitPrimitive {
    
    let red: Double
    let green: Double
    let blue: Double
    
    let opacity: Double
    
    let colorSpace: SColorSpace
    
    var body: Never { fatalError() }
    
    func makeRenderableContent() -> UIKitTargetRenderableContent {
        UIKitColor(primitive: self)
    }
}
