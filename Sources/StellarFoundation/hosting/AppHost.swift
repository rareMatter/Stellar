//
//  AppHost.swift
//  
//
//  Created by Jesse Spencer on 10/25/21.
//

final
class AppHost: CompositeElementHost {
    
    override func mount(beforeSibling sibling: PlatformContent?, onParent parent: ElementHost?, reconciler: TreeReconciler) {
        // TODO: Need transaction param.
        super.prepareForMount()
        
        reconciler.processBody(of: self,
                               hostedElement: \.hostedElementValue)
        
        let childHostedContent = anyApp.body
        let childHost = childHostedContent.makeHost(parentPlatformContent: parentPlatformContent, parentHost: self)
        
        children = [childHost]
        // TODO: Set transaction on child.
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
    
    override func update(inReconciler reconciler: TreeReconciler) {
        // TODO: Handle transaction.
        // TODO: Update variadic views.
        
        reconciler.processBody(of: self,
                               hostedElement: \.hostedElementValue)
        
        let childHostedContent = anyApp.body
        reconciler.reconcileChildren(for: self,
                                     withChild: childHostedContent,
                                     elementType: { getType($0) }, updateChildHost: {
            // TODO: ...
            //            childHost.environmentValues = environmentValues
            $0.hostedElement = .scene(childHostedContent)
            //            childHost.transaction = transaction
        }, mountChildElement: {
            $0.makeHost(parentPlatformContent: parentPlatformContent, parentHost: self)
        })
    }
    
    override func unmount(in reconciler: TreeReconciler, parentTask: UnmountTask?) {
        super.unmount(in: reconciler, parentTask: parentTask)
        children
            .forEach { childHost in
                childHost.unmount(in: reconciler, parentTask: parentTask)
            }
    }
}
