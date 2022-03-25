//
//  CornerRadius.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

extension SCornerRadiusModifier: UIKitModifier {
    var renderableAttributes: [UIKitViewAttribute] {
        [.cornerRadius(value: cornerRadius,
                      antialiased: antialiased)]
    }
}
