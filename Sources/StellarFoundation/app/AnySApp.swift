//
//  AnySApp.swift
//  
//
//  Created by Jesse Spencer on 2/25/21.
//

/// A type-erased SApp value.
public
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
    
    public
    init() {
        fatalError()
    }
    
    public
    var body: some SScene {
        fatalError()
    }
}
