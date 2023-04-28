//
//  SContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

public
protocol SContentModifier: ElementModifier {
    
    associatedtype Body : SContent
    
    @SContentBuilder func body(content: any SContent) -> Self.Body
}
extension SContentModifier {
    public
    func _body(element: CompositeElement) -> CompositeElement {
        guard let content = element as? any SContent else { fatalError() }
        return body(content: content)
    }
}

protocol PrimitiveContentModifier: SContentModifier, PrimitiveModifier
where Body == Never {}
extension PrimitiveContentModifier {
    public
    func body(content: any SContent) -> Never {
        fatalError()
    }
}
