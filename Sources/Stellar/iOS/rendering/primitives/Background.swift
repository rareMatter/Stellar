//
//  Background.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension BackgroundModifierContainer: UIKitPrimitive {
    var renderedBody: AnySContent {
        .init(UIKitZStackPrimitive(alignment: alignment,
                                   content: {
            background
            content
        }))
    }
}
