//
//  UIViewController+Toolbar.swift
//  
//
//  Created by Jesse Spencer on 4/23/21.
//

import SwiftUI

extension UIViewController {
    
    /// Adds a toolbar to the bottom of the view.
    func toolbar<Content: View>(@ViewBuilder content: () -> Content) -> ViewHierarchyObject {
        ToolbarContainerViewController(contentViewController: self, toolbar: content)
    }
}
