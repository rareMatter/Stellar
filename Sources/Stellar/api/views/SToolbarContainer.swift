//
//  SToolbarContainer.swift
//  
//
//  Created by Jesse Spencer on 4/23/21.
//

import SwiftUI

/// A view which places a toolbar at the bottom of the content view you provide.
///
/// To add a toolbar to any SView, use the 'toolbar()' modifier on that view.
public
struct SToolbarContainer<ContentView, ToolbarView>: SView where ContentView: SView, ToolbarView: View {
    
    let contentView: ContentView
    let toolbarView: () -> ToolbarView
    
    public
    var id: UUID = .init()
    
    public
    var content: ViewHierarchyObject {
        contentView.content
            .toolbar(content: toolbarView)
    }
}
