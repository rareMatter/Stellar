//
//  SContentModifier.swift
//  
//
//  Created by Jesse Spencer on 6/1/21.
//

public
protocol SContentModifier: ElementModifier {
    
    typealias Content = _SContentModifierProxy<Self>
    associatedtype Body : SContent
    
    @SContentBuilder func body(content: Self.Content) -> Self.Body
}
extension SContentModifier {
    public
    func _body(element: CompositeElement) -> CompositeElement {
        guard let content = element as? Content else { fatalError() }
        return body(content: .init(modifier: self, content: content))
    }
}

protocol PrimitiveContentModifier: SContentModifier, PrimitiveModifier
where Body == Never {}
extension PrimitiveContentModifier {
    public
    func body(content: Content) -> Never {
        primitiveBodyFailure(withType: String(reflecting: Self.self))
    }
}

public
struct _SContentModifierProxy<Modifier>: SContent
where Modifier : SContentModifier {
    let modifier: Modifier
    let content: any SContent
    
    public var body: any SContent {
        content
    }
}
