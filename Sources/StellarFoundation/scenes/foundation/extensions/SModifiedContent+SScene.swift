//
//  ModifiedElement+SScene.swift
//  
//
//  Created by Jesse Spencer on 11/1/22.
//

// MARK: Scene and PrimitiveScene
extension ModifiedElement: SScene, PrimitiveScene
where Content : SScene, Modifier : SSceneModifier {}

// MARK: modifier chains
extension ModifiedElement: SSceneModifier
where Content : SSceneModifier, Modifier : SSceneModifier {}
