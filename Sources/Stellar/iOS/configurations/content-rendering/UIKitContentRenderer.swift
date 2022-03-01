//
//  UIKitContentRenderer.swift
//  
//
//  Created by Jesse Spencer on 5/20/21.
//

import UIKit

@available(*, deprecated, message: "This has been replaced by a new rendering system equivalent.")
/// A type which can represent `SPrimitiveContent` in UIKit.
protocol UIKitContentRenderer {
    func mountContent(on target: UIKitRenderableContent)
}
