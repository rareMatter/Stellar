//
//  AnySModifiedScene.swift
//  
//
//  Created by Jesse Spencer on 11/7/22.
//

protocol AnySModifiedScene {
    var anyScene: any SScene { get }
    var anySModifier: any SSceneModifier { get }
}

extension ModifiedElement: AnySModifiedScene
where Content : SScene, Modifier : SSceneModifier {
    
    var anyScene: any SScene {
        content
    }
    
    var anySModifier: any SSceneModifier {
        modifier
    }
}
