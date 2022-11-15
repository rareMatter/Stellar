//
//  _SSceneModifier.swift
//  
//
//  Created by Jesse Spencer on 11/3/22.
//

import Foundation

protocol SSceneModifier {
    
    associatedtype Body : SScene
    
    @SContentBuilder func body(content: Body) -> Self.Body
}

extension SSceneModifier
where Body == Never {
    
    func body(content: Body) -> Self.Body {}
}
