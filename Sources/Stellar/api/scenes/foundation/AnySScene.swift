//
//  AnySScene.swift
//  
//
//  Created by Jesse Spencer on 11/1/22.
//

import Foundation

struct AnySScene: PrimitiveScene {
    
    /// The type of the wrapped `SScene`.
    let type: Any.Type
    
    /// The name of the type constructor for the wrapped `SScene`.
    let typeConstructorName: String
    
    /// The wrapped `SScene`.
    ///
    /// This is a `var` to be accessible using a ReferenceWritableKeyPath.
    var wrappedScene: Any
    
    /// The type of the `body` of the wrapped `SScene`.
    let bodyType: Any.Type
    
    /// A closure which provides the `body` of the wrapped `SScene`.
    ///
    /// The only parameter is an instance of the corresponding `SScene`.
    /// The `content` property of this object is the corresponding instance.
    let bodyProvider: (Any) -> AnySScene
    
    public
    init<S>(_ erasingContent: S)
    where S : SScene {
        if let anyScene = erasingContent as? AnySScene {
            self = anyScene
        }
        else {
            type = S.self
            self.typeConstructorName = Stellar.typeConstructorName(S.self)
            self.wrappedScene = erasingContent
            bodyType = S.Body.self
            bodyProvider = { scene in
                guard let scene = scene as? S else {
                    fatalError()
                }
                return AnySScene(scene.body)
            }
        }
    }
}

extension AnySScene: ContainerScene {
    var children: [AnySScene] {
        (wrappedScene as? ContainerScene)?.children ?? []
    }
}
