//
//  SModifiedElement+SContent.swift
//  
//
//  Created by Jesse Spencer on 11/14/22.
//

// MARK: content and primitive content conformance
extension ModifiedElement: SContent, SPrimitiveContent
where Content : SContent, Modifier : SContentModifier {
    public var body: Never { fatalError() }
    public var _body: CompositeElement { fatalError() }
}

// MARK: modifier chains
extension ModifiedElement: ElementModifier
where Content : ElementModifier, Modifier : ElementModifier {
    public
    func _body(element: CompositeElement) -> CompositeElement {
        fatalError()
    }
}

extension ModifiedElement: PrimitiveModifier {}

extension ModifiedElement: SContentModifier, PrimitiveContentModifier
where Content : SContentModifier, Modifier : SContentModifier {}
