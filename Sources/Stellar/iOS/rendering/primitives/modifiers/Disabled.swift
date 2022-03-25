//
//  Disabled.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SDisabledContentModifier: UIKitModifier {
    var renderableAttributes: [UIKitViewAttribute] {
        [.disabled(isDisabled)]
    }
}
