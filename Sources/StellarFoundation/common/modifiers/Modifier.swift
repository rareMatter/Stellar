//
//  Modifier.swift
//  
//
//  Created by Jesse Spencer on 4/11/23.
//

import utilities

public
enum Modifier: Hashable, Equatable {
    case content(HashableProxy<any SContentModifier, String>)
    case scene(HashableProxy<any SSceneModifier, String>)
    
    init(_ modifier: ElementModifier) {
        if let sceneModifier = modifier as? any SSceneModifier {
            self = .scene(.init(value: sceneModifier, hashableValue: typeConstructorName(getType(sceneModifier))))
        }
        else if let contentModifier = modifier as? any SContentModifier {
            self = .content(.init(value: contentModifier, hashableValue: typeConstructorName(getType(contentModifier))))
        }
        else { fatalError() }
    }
    
    init(_ modifierProxy: HashableProxy<ElementModifier, String>) {
        if let sceneModifier = modifierProxy.value as? any SSceneModifier {
            self = .scene(.init(value: sceneModifier, hashableValue: modifierProxy.hashableValue))
        }
        else if let contentModifier = modifierProxy.value as? any SContentModifier {
            self = .content(.init(value: contentModifier, hashableValue: modifierProxy.hashableValue))
        }
        else { fatalError() }
    }
}
