//
//  _SSceneModifier.swift
//  
//
//  Created by Jesse Spencer on 11/3/22.
//

public
protocol SSceneModifier {
    
    associatedtype Body : SScene
    
    @SSceneBuilder func body(content: any SScene) -> Self.Body
}

public
extension SSceneModifier
where Body == Never {
    
    func body(content: any SScene) -> Self.Body {
        fatalError()
    }
}

extension SSceneModifier {
    var isPrimitive: Bool {
        Self.Body.self == Never.self
    }
}
