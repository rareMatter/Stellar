//
//  SWindow.swift
//  
//
//  Created by Jesse Spencer on 2/23/21.
//

import Foundation

/// Windows form the basis for hierarchies of view content.
public
protocol SWindow {
    associatedtype Content: SView
    var content: Content { get }
}

// MARK: - ViewHierarchyManager factory
extension SWindow {
    
    /// Creates a new `ViewHierarchyManager`.
    func makeViewHierarchyManager() -> ViewHierarchyManager {
        let viewHierarchyManager = ViewHierarchyManager()
        // install initial view controller in ViewHierarchyManager
        viewHierarchyManager
            .go(to: content,
                withRoute: .primary,
                atLocation: .root,
                withAnimation: false)
        return viewHierarchyManager
    }
}
