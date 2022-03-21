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
    func mount(beforeSibling sibling: UIKitTarget?,
               onParent parent: ElementHost?,
               reconciler: TreeReconciler) {
        super.prepareForMount()
        
        // render body and create a child element host.
        let childBody = reconciler.render(compositeElement: self)
        let child = childBody.makeElementHost(with: reconciler.renderer,
                                              parentTarget: parentTarget,
                                              parent: self)
        // add child host to self and tell it to mount
        children = [child]
        child.mount(beforeSibling: sibling,
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
        
        let childBody = reconciler.render(compositeElement: self)
        
        reconciler.reconcile(compositeElement: self,
                             with: childBody,
                             getElementType: { $0.type },
                             updateChild: { childHost in
            // TODO: ...
//            childHost.environmentValues = environmentValues
            childHost.content = AnySContent(childBody)
//            childHost.transaction = transaction
        },
                             mountChild: { element in
            element.makeElementHost(with: reconciler.renderer,
                                    parentTarget: parentTarget,
                                    parent: self)
        })
    }
    
    override
    func unmount(in reconciler: TreeReconciler,
                 parentTask: UnmountTask<UIKitRenderer>?) {
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
