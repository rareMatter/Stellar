//
//  UIKitComposableModifier.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

/// A modifier supported by `UIKit` which contains it's own child content.
///
/// Apply this protocol to `UIKit` supported primitive modifiers which contain their own child content in order to properly pass that content into the rendering process.
protocol UIKitComposableModifier {
    /// The content provided by the modifier.
    ///
    /// Since modifiers of this type cannot be converted into a `UIKitViewAttribute` like standard `UIKitModifiers` can, generally you should convert the modifier into a content type and return an instance of that type from this property. That content type will own the modifier content as child content. This allows you to recognize the modifier's content during rendering when it's provided to your modifier content type as child content.
    var content: AnySContent { get }
}
