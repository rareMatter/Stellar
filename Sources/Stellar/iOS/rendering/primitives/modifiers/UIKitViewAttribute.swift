//
//  UIKitViewAttribute.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation
import UIKit

/// The rendering modifiers which can be applied to views.
/// These roughly correspond the modifiers provided by the framework.
/// However, in some cases the framework modifiers may be translated into content instead, which means they will not be applied as attributes.
enum UIKitViewAttribute: Hashable {
    
    // MARK: appearance
    case cornerRadius(value: CGFloat, antialiased: Bool)
    
    // MARK: user interaction
    case disabled(Bool)
    case tapHandler(SHashableClosure)
    
    // MARK: identity
    case identifier(AnyHashable)
}
