//
//  CompositeViewHost.swift
//  
//
//  Created by Jesse Spencer on 10/25/21.
//

import Foundation

final
class CompositeViewHost: CompositeElementHost {
    
    override
    func mount(beforeSibling sibling: PlatformContent?,
               onParent parent: ElementHost?,
               reconciler: TreeReconciler) {
        super.prepareForMount()
        
        // tell the reconciler to process self's hosted content
        reconciler.processBody(of: self,
                               hostedElement: \.anyContent.content)
        
        // create a child host for the body of self's hosted content after it has been processed
        let childHostedContent = anyContent
            .bodyProvider(anyContent.content)
        let childHost = childHostedContent
            .makeHost(parentPlatformContent: parentPlatformContent,
                      parentHost: self)
        
        // add child host to self and tell it to mount
        children = [childHost]
        childHost.mount(beforeSibling: sibling,
                        onParent: self,
                        reconciler: reconciler)
        
        // TODO: schedule post-render callbacks to handle appearance actions and update preferences.
        /*
        reconciler.afterCurrentRender { [weak self] in
            guard let self = self else { return }
            
        }
         */
        
        super.mount(beforeSibling: sibling,
                    onParent: parent,
                    reconciler: reconciler)
    }
    
    override
    func update(inReconciler reconciler: TreeReconciler) {
        // TODO: Handle transaction.
        // TODO: Update variadic views.
        
        // tell the reconciler to process self's hosted content
        // In tokamak:
        // - when self's element is "renderer primitive", the element returned by the renderer would be added as a child here.
        // - when self's element is NOT "renderer primitive" and has a body, the 'render' function would call the body and that would be used here.
        reconciler.processBody(of: self,
                               hostedElement: \.anyContent.content)
        
        // TODO: Why is the reconcile function asking this instance to handle child behaviors in closures?
        // reconcile state changes with child content
        let childHostedContent = anyContent
            .bodyProvider(anyContent.content)
        reconciler.reconcileChildren(for: self,
                                     withChild: childHostedContent,
                                     elementType: { $0.type },
                                     updateChildHost: {
            // TODO: ...
            //            childHost.environmentValues = environmentValues
            $0.hostedElement = .content(.init(childHostedContent))
            //            childHost.transaction = transaction
        },
                                     mountChildElement: { $0.makeHost(parentPlatformContent: parentPlatformContent,
                                                                             parentHost: self) })
    }
    
    override
    func unmount(in reconciler: TreeReconciler,
                 parentTask: UnmountTask?) {
        super.unmount(in: reconciler,
                      parentTask: parentTask)
        
        // TODO: transaction.
        
        // unmount children
        children.forEach { childHost in
            // TODO: view traits.
            //            host.viewTraits = viewTraits
            childHost.unmount(in: reconciler,
                         parentTask: parentTask)
        }
        
        // TODO: Call appearance action.
    }
}
