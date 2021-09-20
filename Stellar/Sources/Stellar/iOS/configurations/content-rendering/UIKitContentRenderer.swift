//
//  UIKitContentRenderer.swift
//  
//
//  Created by Jesse Spencer on 5/20/21.
//

import UIKit

/// A type which can represent `SPrimitiveContent` as a `UIContentConfiguration`.
protocol UIKitContentRenderer {
    func mountContent(on target: UIKitRenderableContent)
}
