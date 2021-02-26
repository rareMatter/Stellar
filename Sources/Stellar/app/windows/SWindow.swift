//
//  File.swift
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

// MARK: - RootController synthesis
extension SWindow {
    /// Creates a new `RootController` from self.
    func makeRootController() -> RootController {
        let rootController = RootController()
        rootController
            .show(viewController: content.content,
                  with: content.route,
                  at: content.location,
                  withAnimation: true)
        return rootController
    }
}
