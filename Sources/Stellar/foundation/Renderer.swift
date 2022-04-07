//
//  Renderer.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

/// Renderers handle platform-specific rendering of the `Descriptive Tree`. A renderer is responsible for creating, updating, and removing the hierarchy of renderable content on a platform when told to do so by the `Tree Reconciler`.
///
/// You can think of a renderer as the manager of the platform's renderable content hierarchy. The renderer assembles, updates, and disassembles the platform's renderable content when told to do so by the `Tree Reconciler`. The `Tree Reconciler` does this as it inspects and later notices changes in the `Descriptive Tree` and uses that information to form the `Live Tree`.
protocol Renderer: AnyObject {
    
    /// The type which will contain necessary information for rendering on a platform.
    associatedtype RenderableTarget: PlatformRenderable
    
    /// Creates a rendering target for the host's content, places it into the platform's renderable hierarchy using the parent and sibling, and returns it.
    ///
    /// - parameters:
    ///     - sibling: Insert the new target before this `sibling` as a child of `parent` to maintain correct ordering. If `sibling` is `nil`, you can simply append the new target to the collection of children. Generally, a sibling is provided when an existing child is being swapped out for a new one.
    ///     - parent: A target that will own the newly created target instance as it's child.
    ///     - host: The `Live Tree` host which stores and manages the new target.
    /// - returns: The created rendering target or nil if one cannot be created. If nil is returned, rendering will be incorrect compared to the `Descriptive Tree` because this rendering target and any children it may contain will be skipped.
    func makeTarget(for host: PrimitiveViewHost<Self>,
                    beforeSibling sibling: RenderableTarget?,
                    withParent parent: RenderableTarget) -> RenderableTarget?
    
    /// Updates the target using the host's content.
    ///
    /// - parameters:
    ///     - target: The target to be updated.
    ///     - host: The host of `target`.
    func update(_ target: RenderableTarget,
                with host: PrimitiveViewHost<Self>)
    
    /// Removes the target from the platform's renderable hierarchy.
    ///
    /// - parameters:
    ///     - target: The target to be removed.
    ///     - parent: The parent of the `target`.
    func remove(_ target: RenderableTarget,
                fromParent parent: RenderableTarget,
                withTask task: UnmountHostTask<Self>)
}
