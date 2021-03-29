//
//  File.swift
//  
//
//  Created by Jesse Spencer on 2/25/21.
//

import UIKit

/// A type-erased SView.
struct AnySView: SView {

    var id: UUID
    
    var content: ViewHierarchyObject
    
    init<View: SView>(view: View) {
        self.id = view.id
        self.content = view.content
    }
    
    init() {
        fatalError()
    }
}
