//
//  File.swift
//  
//
//  Created by Jesse Spencer on 2/25/21.
//

import UIKit

/// A type-erased SView.
struct AnySView: SView {
    
    var content: ViewHierarchyObject {
        contentProvider()
    }
    private let contentProvider: () -> ViewHierarchyObject
    
    init<View: SView>(view: View) {
        self.contentProvider = { view.content }
    }
    
    init() {
        fatalError()
    }
}
