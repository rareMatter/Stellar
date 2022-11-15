//
//  UIKitRenderableContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/14/21.
//

import Foundation

@available(*, deprecated, message: "This has been replaced by the new rendering system equivalent.")
protocol UIKitRenderableContentModifier {
    func applyTo(_ target: UIKitRenderableContent)
}
