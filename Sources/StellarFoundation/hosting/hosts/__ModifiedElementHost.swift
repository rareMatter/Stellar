//
//  __ModifiedElementHost.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

import OrderedCollections
import utilities

struct __ModifiedElementHost: _Host {
    
    var element: CompositeElement {
        get { modifiedElement }
        set {
            guard let modifiedElement = newValue as? AnyModifiedElement else { fatalError() }
            self.modifiedElement = modifiedElement
        }
    }
    private
    var modifiedElement: AnyModifiedElement
    
    private(set)
    var unwrappedElement: CompositeElement? = nil
    private(set)
    var modifiers: OrderedSet<HashableProxy<ElementModifier, String>> = .init()
    
    var elementChildren: [CompositeElement] {
        unwrappedElement != nil ? [unwrappedElement!] : []
    }
    
    init(modifiedElement: AnyModifiedElement & PrimitiveElement) {
        self.modifiedElement = modifiedElement
    }
    
    mutating
    func render(with context: RenderContext, enqueueUpdate: @autoclosure () -> Void) -> RenderOutput {
        _processContent(context: context)
        return .init(renderedElement: nil, children: elementChildren, modifiers: modifiers)
    }
    
    mutating
    func update(with context: RenderContext, enqueueUpdate: @autoclosure () -> Void) -> RenderOutput {
        _processContent(context: context)
        return .init(renderedElement: nil, children: elementChildren, modifiers: modifiers)
    }
    
    mutating
    func dismantle(with context: RenderContext) {}
        
    mutating
    func _processContent(context: RenderContext) {
        let result = reduceModifiedElement(modifiedElement)
        unwrappedElement = result.element
        modifiers = context.modifiers
        modifiers.replaceAndAppend(contentsOf: result.modifiers)
    }
    
    private
    mutating
    func reduceModifiedElement(_ element: AnyModifiedElement) -> (modifiers: OrderedSet<HashableProxy<ElementModifier, String>>, element: CompositeElement) {
        
        func reduceModifiedElementRecursively(element: CompositeElement, collection: inout OrderedSet<HashableProxy<ElementModifier, String>>) -> CompositeElement {
            
            // Recursively unravel modifier chain, accumulating primitive modifiers and calling modifier bodies. End recursion when the wrapped element is encountered.
            guard let modifiedElement = element as? AnyModifiedElement else {
                return element
            }
            
            #warning("Bug")
            // FIXME: This likely fails for certain cases. Unwrapping of chained modifiers should probably be handled first, before resolving composed modifiers and accumulating primitive modifiers.
            // primitive
            if modifiedElement.anyModifier is PrimitiveModifier {
                collection.append(.init(value: modifiedElement.anyModifier, hashableValue: typeConstructorName(getType(modifiedElement.anyModifier))))
                return modifiedElement.anyElement
            }
            // chained modifier
            // TODO: Should ModifiedElement reduce chains automatically in its init? Was this considered before and if so why was it not implemented? Possibly because type information would be lost before rendering.
            else if let wrappedModifiedElement = modifiedElement.anyElement as? AnyModifiedElement {
                collection.append(.init(value: wrappedModifiedElement.anyModifier, hashableValue: typeConstructorName(getType(wrappedModifiedElement))))
                return reduceModifiedElementRecursively(element: wrappedModifiedElement.anyElement, collection: &collection)
            }
            // composed modifier
            else {
                let content = modifiedElement.anyModifier._body(element: modifiedElement.anyElement)
                return reduceModifiedElementRecursively(element: content, collection: &collection)
            }
        }
        
        var modifiers = OrderedSet<HashableProxy<ElementModifier, String>>()
        let element = reduceModifiedElementRecursively(element: element, collection: &modifiers)
        return (modifiers, element)
    }
}
