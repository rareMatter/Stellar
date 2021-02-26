//
//  File.swift
//  
//
//  Created by Jesse Spencer on 2/25/21.
//

import Foundation

/// A type-erased SWindow.
struct AnySWindow: SWindow {
    
    var content: AnySView {
        anyView()
    }
    private let anyView: () -> AnySView
    
    init<Window: SWindow>(window: Window) {
        self.anyView = { AnySView(view: window.content) }
    }
}
