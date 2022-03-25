//
//  UIKitModifier.swift
//  
//
//  Created by Jesse Spencer on 3/24/22.
//

import Foundation

/// A modifier supported by `UIKit`.
///
/// Check for conformance to this protocol when converting modified content primitive instances into UIKit renderable instances (generally as a generic constraint).
protocol UIKitModifier {
    /// A renderable description of the modifier primitive.
    /// This is a collection because modifiers may be chained and flattened into one instance.
    var renderableAttributes: [UIKitViewAttribute] { get }
}
