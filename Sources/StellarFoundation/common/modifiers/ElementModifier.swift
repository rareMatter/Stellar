//
//  ElementModifier.swift
//  
//
//  Created by Jesse Spencer on 3/31/23.
//

/// A modifier that can be applied to an element.
public
protocol ElementModifier {
    func _body(element: CompositeElement) -> CompositeElement
}

typealias ModifierHashProxy = HashableProxy<ElementModifier, String>
