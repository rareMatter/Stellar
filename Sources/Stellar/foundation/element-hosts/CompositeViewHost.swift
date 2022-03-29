//
//  CompositeViewHost.swift
//  
//
//  Created by Jesse Spencer on 10/25/21.
//

import Foundation

final
class CompositeViewHost<R: Renderer>: CompositeElementHost<R> {
    
    override
    func mount(beforeSibling sibling: R.TargetType?,
               onParent parent: ElementHost<R>?,
               reconciler: TreeReconciler<R>) {
        super.prepareForMount()
        
        // render element and create a child element host
        let renderedHostedElement = reconciler.render(compositeView: self)
        let childHost = renderedHostedElement.makeElementHost(with: reconciler.renderer,
                                              parentTarget: parentTarget,
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
    func update(inReconciler reconciler: TreeReconciler<R>) {
        // TODO: Handle transaction.
        // TODO: Update variadic views.
        
        let renderedHostedElement = reconciler.render(compositeView: self)
        
        reconciler.reconcile(compositeElement: self,
                             with: renderedHostedElement,
                             getElementType: { $0.type },
                             updateChild: { childHost in
            // TODO: ...
//            childHost.environmentValues = environmentValues
            childHost.content = AnySContent(renderedHostedElement)
//            childHost.transaction = transaction
        },
                             mountChild: { element in
            element.makeElementHost(with: reconciler.renderer,
                                    parentTarget: parentTarget,
                                    parentHost: self)
        })
    }
    
    override
    func unmount(in reconciler: TreeReconciler<R>,
                 parentTask: UnmountTask<R>?) {
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
