//
//  PlatformRenderable.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

/// An object which can be rendered by a specific platform.
protocol PlatformRenderable: AnyObject {
    
    /// The content to be rendered by the platform.
    var content: AnySContent { get set }
}
