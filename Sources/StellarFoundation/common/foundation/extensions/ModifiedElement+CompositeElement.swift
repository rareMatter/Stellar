//
//  ModifiedElement+CompositeElement.swift
//  
//
//  Created by Jesse Spencer on 3/30/23.
//

extension ModifiedElement: CompositeElement, PrimitiveElement
where Content : CompositeElement, Modifier : ElementModifier {
    public var _body: CompositeElement { fatalError() }
}
