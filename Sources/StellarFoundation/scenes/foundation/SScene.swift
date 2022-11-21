//
//  SScene.swift
//  
//
//  Created by Jesse Spencer on 11/1/22.
//

public
protocol SScene {
    /// The body type provided by this scene.
    associatedtype Body : SScene
    
    // TODO: Needs @MainActor.
    /// The body of the scene.
    @SSceneBuilder var body: Self.Body { get }
}
