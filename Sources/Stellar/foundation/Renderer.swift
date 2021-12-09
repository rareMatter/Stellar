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
    /// - parameter sibling: A sibling is provided to allow correct ordering of a new target when being added to the parent target as a child. The new target should be inserted before the sibling. The value of the sibling is a view which will be removed from the `Live Tree` after mounting has finished. Generally, a sibling value is only provided when `GroupedContent` (which is not rendered) appears in the `Descriptive Tree`. The `GroupedContent` is removed from the chain during rendering and therefore a sibling is provided to ensure correct ordering during `Live Tree` updates.
    /// - parameter parent: Parent target that will own a newly created target instance.
    /// - parameter host: The host view that renders to the newly created target.
    /// - returns: The newly created target or nil.
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
