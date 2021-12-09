//
//  RenderableTarget.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

/// A target which can be rendered by a specific platform.
protocol RenderableTarget: AnyObject {
    
    /// The content which the target should visually represent on the platform by creating a renderable equivalent.
    var content: AnySContent { get set }
}
