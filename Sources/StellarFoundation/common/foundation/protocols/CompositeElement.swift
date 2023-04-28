//
//  CompositeElement.swift
//  
//
//  Created by Jesse Spencer on 3/30/23.
//

public
protocol CompositeElement {
    // TODO: Can a generic function builder be constructed to avoid this approach?
    var _body: CompositeElement { get }
}
