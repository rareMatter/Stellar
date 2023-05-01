//
//  ModifiedElement+SScene.swift
//  
//
//  Created by Jesse Spencer on 11/1/22.
//

// MARK: Scene and PrimitiveScene
extension ModifiedElement: SScene, PrimitiveScene
where Content : SScene, Modifier : SSceneModifier {
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}

// MARK: modifier chains
extension ModifiedElement: SSceneModifier, PrimitiveSceneModifier
where Content : SSceneModifier, Modifier : SSceneModifier {}
