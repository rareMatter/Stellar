//
//  PlatformContent.swift
//  
//
//  Created by Jesse Spencer on 4/22/22.
//

import Foundation

/// Content which can be understood by a specific platform.
///
/// A conforming type forms a hierarchy of content which can be used to render on a platform. Generally, these types are created by mapping a primitive `Content` type into a platform-specific conforming type.
///
/// An instance must be able to create, add, and remove children, and update itself using provided state.
protocol PlatformContent {
    
    /// Creates rendered content for the host's content, which is a child of this content, and places it into the platform's rendered hierarchy before the sibling. The new rendered content is returned in order to be hosted.
    ///
    /// Use the host to retrieve the content to be rendered and other relevant state. Generally, you should add the new rendered instance to your hierarchy before returning it.
    func makeChild(using host: PrimitiveViewHost,
                   preceeding sibling: PlatformContent?) -> PlatformContent
    
    /// Updates rendered state of self using the provided host's state.
    func update(using host: PrimitiveViewHost)
    
    /// Removes the child using the task as needed.
    func remove(_ child: PlatformContent,
                for task: UnmountHostTask)
}
