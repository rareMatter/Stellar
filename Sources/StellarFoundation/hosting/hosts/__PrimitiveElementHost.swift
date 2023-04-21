//
//  __PrimitiveElementHost.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

import utilities

struct __PrimitiveElementHost: _PrimitiveElementHost {
    
    var element: CompositeElement
    var renderedElement: PlatformContent?
    
    var elementChildren: [CompositeElement] {
        // TODO: perhaps a specialized case of primitive host should be made for list containers, and group containers.
        if let container = element as? any CollectionBox<CompositeElement> {
            return container.children
        }
        else { return [] }
    }
    
    init(element: PrimitiveElement, renderedElement: PlatformContent? = nil) {
        self.element = element
        self.renderedElement = renderedElement
    }
    
    mutating
    func render(with context: RenderContext, enqueueUpdate: @escaping () -> Void) -> RenderOutput? {
        #warning("This is creating and storing a rendered element and then returning a copy. Reference-type is not required of rendered elements. This behavior may be inconsistent to platform architectures and cause side-effect bugs. Either reference types should be required, or storage of a rendered element should be consolidated. Why is the rendered element stored in nodes? To be passed down for child appending?")
        // render
        let primitiveContext = PrimitiveContext(value: element)
        renderedElement = context
            .parentRenderedElement.value
            .addChild(for: primitiveContext,
                      modifiers: context.modifiers.map(Modifier.init),
                      context: .init())
        
        return .init(renderedElement: renderedElement, modifiers: nil, children: elementChildren)
    }
    
    mutating
    func update(with context: RenderContext, enqueueUpdate: @escaping () -> Void) -> RenderOutput? {
        // TODO:
        /*
         parentUnmountTask.cancel()
         parentUnmountTask.completeImmediately()
         parentUnmountTask = .init()
         */
        /*
         updateEnvironment()
         */
        renderedElement?
            .update(with: PrimitiveContext(value: element),
                    modifiers: context.modifiers.map(Modifier.init))
        
        return .init(renderedElement: renderedElement, modifiers: nil, children: elementChildren)
    }
    
    mutating
    func dismantle(with context: DismantleContext) {
        // TODO: Move to reconciler.
        /*
         guard let platformContent = platformContent else { return }
         
         let task = UnmountHostTask(self,
         in: reconciler) {
         self.children.forEach { childHost in
         childHost.unmount(in: reconciler,
         parentTask: self.unmountTask)
         }
         }
         
         task.isCancelled = parentTask?.isCancelled ?? false
         unmountTask = task
         parentTask?.childTasks.append(task)
         parentPlatformContent.removeChild(platformContent,
         for: task)
         */
    }
}
