//
//  AnySApp.swift
//  
//
//  Created by Jesse Spencer on 2/25/21.
//

import Foundation

/// A type-erased SApp value.
struct AnySApp: SApp {
    
    var app: Any
    let type: Any.Type
    let bodyClosure: (Any) -> AnySScene
    let bodyType: Any.Type
    
    init<A>(_ app: A)
    where A : SApp {
        self.app = app
        type = A.self
        bodyClosure = { AnySScene(($0 as! A).body) }
        bodyType = A.Body.self
    }
    
    init() {
        fatalError()
    }
    
    var body: some SScene {
        fatalError()
    }
}
