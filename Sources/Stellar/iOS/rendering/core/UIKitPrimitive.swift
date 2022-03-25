//
//  UIKitPrimitive.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

/// A type which can be rendered by `UIKit`.
///
/// For any framework primitives which can be rendered by `UIKit`, make them conform to this protocol where they should be converted into a `UIKit` renderable primitive type, represented by `UIKitPrimitiveType` and type-erased for recognition during render using `AnyUIKitPrimitive`.
protocol UIKitPrimitive {
    var renderedBody: AnySContent { get }
}

/// This protocol allows recognition of any `UIKit` primitive type and defines common requirements.
protocol AnyUIKitPrimitive {
    /// Creates UIKit renderable content.
    func makeRenderableContent() -> UIKitTargetRenderableContent
}
