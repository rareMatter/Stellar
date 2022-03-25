//
//  TapHandler.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension STapHandlerModifier: UIKitModifier {
    var renderableAttributes: [UIKitViewAttribute] {
        [.tapHandler(.init(tapHandler))]
    }
}
