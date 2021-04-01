//
//  STitleBarView.swift
//  
//
//  Created by Jesse Spencer on 3/27/21.
//

import Foundation
import SwiftUI

/// A simple encapsulation of `UINavigationItem` properties.
public
struct STitleBarView {
    
    private
    var titleBarProvider: (() -> AnyView)?
    
    /// A title to set on the nav bar. This, and any individual nav bar properties, are overidden by titleBarProvider.
    private
    var title: String?
    /// A subtitle to set on the nav bar, its `prompt`. This, and any individual nav bar properties, are overidden by titleBarProvider.
    private
    var subtitle: String?
    
    public
    init() {
    }
    
    var content: UINavigationItem {
        let navItem = UINavigationItem(title: "")
        
        if let titleBarProvider = titleBarProvider {
            let titleView = UIHostingController(rootView: titleBarProvider()).view
            titleView?.backgroundColor = .clear
            navItem.titleView = titleView
        }
        else {
            navItem.title = title
            navItem.prompt = subtitle
        }
        
        return navItem
    }
}

// MARK: - API
public
extension STitleBarView {
    
    func titleView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> Self {
        var modified = self
        modified.titleBarProvider = {
            AnyView(content())
        }
        return self
    }
    
    func title(_ text: StringLiteralType) -> Self {
        var modified = self
        modified.title = text
        return modified
    }
    
    func subtitle(_ text: StringLiteralType) -> Self {
        var modified = self
        modified.subtitle = text
        return modified
    }
}

// MARK: `UINavigationItem` mapping
extension UINavigationItem {
    
    func copy(propertiesFrom otherNavItem: UINavigationItem) {
        title = otherNavItem.title
        largeTitleDisplayMode = otherNavItem.largeTitleDisplayMode
        backBarButtonItem = otherNavItem.backBarButtonItem
        backButtonTitle = otherNavItem.backButtonTitle
        backButtonDisplayMode = otherNavItem.backButtonDisplayMode
        hidesBackButton = otherNavItem.hidesBackButton
        prompt = otherNavItem.prompt
        leftBarButtonItem = otherNavItem.leftBarButtonItem
        rightBarButtonItem = otherNavItem.rightBarButtonItem
        leftBarButtonItems = otherNavItem.leftBarButtonItems
        rightBarButtonItems = otherNavItem.rightBarButtonItems
        standardAppearance = otherNavItem.standardAppearance
        compactAppearance = otherNavItem.compactAppearance
        scrollEdgeAppearance = otherNavItem.scrollEdgeAppearance
        searchController = otherNavItem.searchController
        hidesSearchBarWhenScrolling = otherNavItem.hidesSearchBarWhenScrolling
    }
}

