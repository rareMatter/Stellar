//
//  File.swift
//  
//
//  Created by Jesse Spencer on 2/25/21.
//

import UIKit

/// A type-erased SView.
public
struct AnySView: SView {

    public var id: UUID
    
    public var content: ViewHierarchyObject
    
    init<View: SView>(view: View) {
        self.id = view.id
        self.content = view.content
    }
    
    init() {
        fatalError()
    }
}
