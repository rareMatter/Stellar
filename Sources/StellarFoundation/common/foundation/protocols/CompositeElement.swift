//
//  CompositeElement.swift
//  
//
//  Created by Jesse Spencer on 3/30/23.
//

import Foundation

// TODO: App, scene, and content protocols should inherit from this.
// TODO: Can a generic function builder be constructed to avoid this approach?
// TODO: What is the performance impact of @dynamicMemberLoookup?
/// Inheritance must be inverted for now - in other words, App, Scene, and Content should inhertit from this but due to expressivity limits on protocols, instead each much conform to this protocol.
@dynamicMemberLookup
public
protocol CompositeElement {
    var _body: CompositeElement { get }
}
extension CompositeElement {
    internal
    subscript(dynamicMember string: String) -> Any? {
        if let value = self[dynamicMember: string] {
            return value
        }
        else { return nil }
    }
    
    public
    var _body: CompositeElement {
        guard let value = self[dynamicMember: "body"],
              let compositeElement = value as? CompositeElement else { fatalError() }
        return compositeElement
    }
}
