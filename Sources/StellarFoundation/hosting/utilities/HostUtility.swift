//
//  HostUtility.swift
//  
//
//  Created by Jesse Spencer on 4/10/23.
//

public
enum HostUtility {}

extension HostUtility {
    
    /// Creates a host appropriate for the type of element.
    public
    static
    func makeHost(for element: CompositeElement) -> _Host {
        // empty
        if let empty = element as? EmptyElement {
            return _EmptyElementHost(element: empty)
        }
        // primitives
        else if let modifiedElement = element as? AnyModifiedElement {
            return __ModifiedElementHost(modifiedElement: modifiedElement)
        }
        else if let primitive = element as? PrimitiveElement {
            return __PrimitiveElementHost(element: primitive)
        }
        // composites
        else {
            return __CompositeElementHost(element: element)
        }
    }
}
