//
//  AnySModifiedScene.swift
//  
//
//  Created by Jesse Spencer on 11/7/22.
//

import Foundation

protocol AnySModifiedScene {
    var anyScene: AnySScene { get }
    var anySModifier: AnySSceneModifier { get }
}

extension SModifiedContent: AnySModifiedScene
where Content : SScene, Modifier : SSceneModifier {
    
    var anyScene: AnySScene {
        AnySScene(content)
    }
    
    var anySModifier: AnySSceneModifier {
        AnySSceneModifier(modifier)
    }
}
