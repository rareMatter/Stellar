//
//  Renderer.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

protocol Renderer: AnyObject {
    
    /// The type which will contain necessary information for rendering on a platform.
    associatedtype TargetType: RenderableTarget
    
    /// Called by the reconciler when a new target instance should be created and added to the parent (either as a subview or some other way, e.g. installed if it's a layout constraint).
    ///
    /// - parameter sibling: Insert the new target before this `sibling` as a child of `parent` to maintain correct ordering. If `sibling` is nil, you can simply append the new target to the collection of children. Generally, a sibling is provided when a child is being swapped out.
    /// - parameter parent: A target that will own the newly created target instance as its child.
    /// - parameter host: The host which stores and manages the new target.
    /// - returns: A new target or nil if none should be created.
    func mountTarget(before sibling: TargetType?,
                     on parent: TargetType,
                     with host: ElementHost) -> TargetType?
    
    /// Called by the reconciler when an existing rendering target instance should be updated.
    ///
    /// Update the target using the host's content.
    ///
    /// - parameters:
    ///     - target: The existing target instance which needs to be updated.
    ///     - host: The host of the rendered content which needs to be updated.
    func update(target: TargetType,
                with host: ElementHost)
    
    /// Called by the reconciler when an existing target instance should be removed from the tree.
    ///
    /// - parameters:
    ///     - target: The target instance which should be removed.
    ///     - parent: The parent of the target instance.
    func unmount(target: TargetType,
                 from parent: TargetType,
                 withTask task: UnmountHostTask<Self>)
    
    /// Asks for the rendered version of the primitive content.
    func bodyFor(primitiveContent: Any) -> AnySContent?
    
    /// Asks the renderer if the primitive content type can be rendered.
    func isPrimitiveContent(_ type: Any.Type) -> Bool
}
