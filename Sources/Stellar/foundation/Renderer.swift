//
//  Renderer.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

/// Renderers handle platform-specific rendering needs. A renderer is responsible for creating, updating, and removing the hierarchy of renderable content on a platform when told to do so by a Tree Reconciler.
///
///
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
                     with host: PrimitiveViewHost<Self>) -> TargetType?
    
    /// Called by the reconciler when an existing rendering target instance should be updated.
    ///
    /// Update the target using the host's content.
    ///
    /// - parameters:
    ///     - target: The existing target instance which needs to be updated.
    ///     - host: The host of the rendered content which needs to be updated.
    func update(target: TargetType,
                with host: PrimitiveViewHost<Self>)
    
    /// Called by the reconciler when an existing target instance should be removed from the tree.
    ///
    /// - parameters:
    ///     - target: The target instance which should be removed.
    ///     - parent: The parent of the target instance.
    func unmount(target: TargetType,
                 from parent: TargetType,
                 withTask task: UnmountHostTask<Self>)
    
    // TODO: These functions have two primary effects as currently used: 1) implicitly allows the renderer to direct how a framework primitive is hosted (from a PrimitiveViewHost to a CompositeViewHost); 2) explicitly allows the renderer to swap out an API primitive type to any SContent type it chooses.
    // TODO: 1) means that if the renderer claims a type will be mapped in `isPrimitiveContent` and does not provide one from `platformMap`, that type's body will be called even if its actually primitive. Therefore, if the renderer claims a type will be mapped in `isPrimitiveContent`, that type MUST be provided by `platformMap`.
    // TODO: The framework processes the provided primitive type before asking to have it mapped by the renderer.
    /// Maps the provided primitive content to a platform-provided type if needed. Simply return the provided type is no mapping is necessary.
    ///
    /// If nil is returned, the content will be skipped and the renderer should expect to *not* encounter the instance in the `Descriptive Tree` hierarchy. This may be useful in some scenarios but should be avoided in order to match the `Live Tree` exactly to the `Descriptive Tree` as expected.
    func platformMap(primitiveContent: Any) -> AnySContent?
    
    // TODO: Can this be removed to simplify and clarify renderer requirements, while still allowing internal components to utilize `bodyFor` for the same purpose? It seems having these two function as separate allows for a gap for inconsistency and ultimately crashes.
    // TODO: This should probably not mention primitive content - the content associated with this method is treated as composite by the reconciler. Call it `shouldMap`?
    /// Asks the renderer if the primitive content type can be rendered.
    func isPrimitiveContent(_ type: Any.Type) -> Bool
}
