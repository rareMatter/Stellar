//
//  PrimitiveScene.swift
//  
//
//  Created by Jesse Spencer on 11/3/22.
//

public
protocol PrimitiveScene: SScene, PrimitiveElement
where Self.Body == Never {}

public
extension PrimitiveScene
where Self.Body == Never {
    var body: Never { fatalError() }
}
