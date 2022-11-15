//
//  AnySSceneModifier.swift
//  
//
//  Created by Jesse Spencer on 11/7/22.
//

import Foundation

public
struct AnySSceneModifier: SSceneModifier {
    
    /// The type of the wrapped `SSceneModifier`.
    let type: Any.Type
    
    let typeConstructorName: String
    
    /// The type-erased modifier.
    let modifier: Any
    
    /// The type of the `body` of the wrapped `SSceneModifier`.
    let bodyType: Any.Type
    
    private
    let bodyProvider: (Body) -> AnySScene
    
    init<Modifier>(_ erasingModifier: Modifier)
    where Modifier : SSceneModifier {
        if let anyModifier = erasingModifier as? AnySSceneModifier {
            self = anyModifier
        }
        else {
            type = Modifier.self
            typeConstructorName = StellarFoundation.typeConstructorName(Modifier.self)
            modifier = erasingModifier
            bodyType = Modifier.Body.self
            bodyProvider = {
                AnySScene(erasingModifier.body(content: $0 as! Modifier.Body))
            }
        }
    }
    
    func body(content: AnySScene) -> AnySScene {
        bodyProvider(content)
    }
}
extension AnySSceneModifier: Equatable, Hashable {
    
    public static func ==(lhs: AnySSceneModifier, rhs: AnySSceneModifier) -> Bool {
        lhs.typeConstructorName == rhs.typeConstructorName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(typeConstructorName)
    }
}
