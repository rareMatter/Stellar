//
//  HostUtility.swift
//  
//
//  Created by Jesse Spencer on 4/10/23.
//

enum HostUtility {}

extension HostUtility {
    
    /// Creates a host appropriate for the type of element.
    static
    func makeHost(for element: CompositeElement, parentRenderedElement: PlatformContent?) -> _Host {
        // empty
        if let empty = element as? EmptyElement {
            return _EmptyElementHost(element: empty)
        }
        // primitives
        else if let modifiedElement = element as? AnyModifiedElement {
            return __ModifiedElementHost(modifiedElement: modifiedElement)
        }
        else if let primitive = element as? PrimitiveElement {
            return __PrimitiveElementHost(element: primitive, parentRenderedElement: parentRenderedElement!)
        }
        // composites
        else {
            return __CompositeElementHost(element: element)
        }
    }
}
