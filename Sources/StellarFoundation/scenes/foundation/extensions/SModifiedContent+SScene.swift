//
//  SModifiedContent+SScene.swift
//  
//
//  Created by Jesse Spencer on 11/1/22.
//

import Foundation

// MARK: Scene and PrimitiveScene
extension SModifiedContent: SScene, PrimitiveScene
where Content : SScene, Modifier : SSceneModifier {}

// MARK: modifier chains
extension SModifiedContent: SSceneModifier
where Content : SSceneModifier, Modifier : SSceneModifier {}
