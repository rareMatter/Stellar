//
//  _EmptyElementHost.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

final
class _EmptyElementHost: _PrimitiveElementHost {
    
    var element: CompositeElement
    var elementChildren: [CompositeElement] { [] }
    var renderedElement: PlatformContent? = nil
    
    init(element: EmptyElement) {
        self.element = element
    }
    
    func render(with context: RenderContext, enqueueUpdate: @autoclosure () -> Void) -> RenderOutput {}
    
    func update(with context: RenderContext, enqueueUpdate: @autoclosure () -> Void) -> RenderOutput {}
    
    func dismantle(with context: RenderContext) {}
}
