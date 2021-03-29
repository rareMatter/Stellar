//
//  SListView+TitleBar.swift
//  
//
//  Created by Jesse Spencer on 3/27/21.
//

import Foundation

public
extension SListView {
    
    func titleBar(_ titleBarViewProvider: () -> STitleBarView) -> Self {
        var modified = self
        modified.titleBarView = titleBarView
        return modified
    }
}
