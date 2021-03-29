//
//  SListView+Toolbar.swift
//  
//
//  Created by Jesse Spencer on 3/27/21.
//

import Foundation
import SwiftUI

public
extension SListView {
    
    func toolbar<Content: View>(@ViewBuilder content: @escaping (ListState<ItemType>) -> Content) -> Self {
        var modified = self
        modified.toolbarContent = { listState in
            AnyView(content(listState))
        }
        return modified
    }
}
