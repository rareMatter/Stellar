//
//  _SSceneModifier.swift
//  
//
//  Created by Jesse Spencer on 11/3/22.
//

public
protocol SSceneModifier: ElementModifier {
    
    associatedtype Body : SScene
    
    @SSceneBuilder func body(content: any SScene) -> Self.Body
}
extension SSceneModifier {
    public
    func _body(element: CompositeElement) -> CompositeElement {
        guard let scene = element as? Body else { fatalError() }
        return body(content: scene)
    }
}

public
protocol PrimitiveSceneModifier: SSceneModifier, PrimitiveModifier
where Body == Never {}
extension PrimitiveSceneModifier {
    public
    func body(content: any SScene) -> Self.Body {
        fatalError()
    }
}
