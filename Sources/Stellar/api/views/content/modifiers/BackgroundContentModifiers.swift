//
//  BackgroundContentModifiers.swift
//  
//
//  Created by Jesse Spencer on 6/7/21.
//

import Foundation

struct SColorBackgroundContentModifier: SContentModifier {
    typealias Body = Never
    let backgroundColor: SColor
}

struct SDynamicColorBackgroundContentModifier: SContentModifier {
    typealias Body = Never
    let backgroundDynamicColor: SDynamicColor
}

public
extension SContent {
    func background(_ color: SColor) -> some SContent {
        modifier(SColorBackgroundContentModifier(backgroundColor: color))
    }
    
    func background(_ dynamicColor: SDynamicColor) -> some SContent {
        modifier(SDynamicColorBackgroundContentModifier(backgroundDynamicColor: dynamicColor))
    }
}
