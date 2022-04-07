//
//  EmptyElementHost.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

/// A host for empty content.
final
class EmptyElementHost<R: Renderer>: ElementHost<R> {
    
    /// An empty impementation which avoids crashing in super.
    override
    func mount(beforeSibling sibling: R.RenderableTarget?,
               onParent parent: ElementHost<R>?,
               reconciler: TreeReconciler<R>) {
        super.prepareForMount()
        super.mount(beforeSibling: sibling,
                    onParent: parent,
                    reconciler: reconciler)
    }
}
