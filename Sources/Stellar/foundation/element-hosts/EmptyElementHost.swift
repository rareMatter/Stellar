//
//  EmptyElementHost.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

/// A host for empty content.
final
class EmptyElementHost: ElementHost {
    
    /// An empty impementation which avoids crashing in super.
    override
    func mount(beforeSibling sibling: PlatformContent?,
               onParent parent: ElementHost?,
               reconciler: TreeReconciler) {
        super.prepareForMount()
        super.mount(beforeSibling: sibling,
                    onParent: parent,
                    reconciler: reconciler)
    }
}
