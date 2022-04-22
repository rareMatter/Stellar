//
//  UIKitPrimitive.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

/// A type which can be rendered by `UIKit`.
///
/// This is used to designate API primitives as renderable. They will be recognized by the `UIKitRenderer` as needed.
protocol UIKitPrimitive {
    func makeRenderableContent() -> UIKitTargetRenderableContent
}
