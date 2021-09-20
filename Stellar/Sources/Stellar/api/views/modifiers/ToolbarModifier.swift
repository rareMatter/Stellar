//
//  File.swift
//  
//
//  Created by Jesse Spencer on 4/23/21.
//

import SwiftUI

public
extension SView {
    
    /// Adds a toolbar to the bottom of the view using the content you provide.
    func toolbar<Content: View>(@ViewBuilder content: @escaping () -> Content) -> SView {
        SToolbarContainer(contentView: self, toolbarView: content)
    }
}
