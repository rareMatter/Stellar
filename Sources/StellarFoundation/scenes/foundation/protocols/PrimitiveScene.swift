//
//  PrimitiveScene.swift
//  
//
//  Created by Jesse Spencer on 11/3/22.
//

import Foundation

protocol PrimitiveScene: SScene
where Self.Body == Never {}

// MARK: default body
extension PrimitiveScene {
    public var body: Never { fatalError() }
}
