//
//  __PrimitiveElementHost.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

import utilities

struct __PrimitiveElementHost: _PrimitiveElementHost {
    
    var element: CompositeElement
    var parentRenderedElement: PlatformContent
    var renderedElement: PlatformContent?
    
    var elementChildren: [CompositeElement] {
        // TODO: perhaps a specialized case of primitive host should be made for list containers, and group containers.
        if let container = element as? any CollectionBox<CompositeElement> {
            return container.children
        }
        else { return [] }
    }
    
    init(element: PrimitiveElement, parentRenderedElement: PlatformContent, renderedElement: PlatformContent? = nil) {
        self.element = element
        self.parentRenderedElement = parentRenderedElement
        self.renderedElement = renderedElement
    }
    
    mutating
    func render(with context: RenderContext, enqueueUpdate: @autoclosure () -> Void) -> RenderOutput {
        // GroupingElements are not rendered, so the parent rendered element is simply passed down.
        if element is any GroupingElement {
            self.renderedElement = parentRenderedElement
        }
        // render
        else {
            self.renderedElement = parentRenderedElement.addChild(for: .init(value: element), modifiers: context.modifiers.map(Modifier.init), context: .init())
        }
        
        return .init(renderedElement: renderedElement, children: elementChildren, modifiers: context.modifiers)
    }
    
    mutating
    func update(with context: RenderContext, enqueueUpdate: @autoclosure () -> Void) -> RenderOutput {
        <#code#>
    }
    
    mutating
    func dismantle(with context: RenderContext) {
        <#code#>
    }
}
