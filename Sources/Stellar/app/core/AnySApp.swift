//
//  AnySApp.swift
//  
//
//  Created by Jesse Spencer on 2/25/21.
//

import Foundation

/// A type-erased SApp. This allows storage of an NLApp conforming property in non-generic types.
struct AnySApp: SApp {
    
    init() {
        fatalError()
    }
    
    var window: AnySWindow {
        windowProvider()
    }
    private let windowProvider: () -> AnySWindow
    
    init<App: SApp>(app: App) {
        self.windowProvider = { AnySWindow(window: app.window) }
    }
}
