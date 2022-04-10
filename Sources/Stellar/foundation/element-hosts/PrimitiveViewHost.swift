//
//  PrimitiveViewHost.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

/// A content host whose hosted content is primitive.
///
/// The lifecycle of this host is managed by the reconciler in order to provide `Descriptive Tree` hosting. Updates are handled through this type and other similar types in the `Live Tree` managed by the `TreeReconciler`.
final
class PrimitiveViewHost<R: Renderer>: ElementHost<R> {
    
    /// Target of the closest ancestor host view.
    ///
    /// A parent of this view might be a composite, therefore it must be passed to the first descendant host views.
    ///
    /// This means the `parentTarget` is not always the same as the target of a parent `View`.
    private
    let parentTarget: R.RenderableTarget
    
    /// Renderable target of this host, supplied by the platform renderer after mounting.
    private(set)
    var target: R.RenderableTarget?
    
    private
    var parentUnmountTask = UnmountTask<R>()
    
    init(content: AnySContent,
         parentTarget: R.RenderableTarget,
         parent: ElementHost<R>?) {
        self.parentTarget = parentTarget
        
        super.init(hostedElement: .content(content),
                   parent: parent)
    }
    
    // TODO: Need transaction and reconciler params.
    override
    func mount(beforeSibling sibling: R.RenderableTarget?,
               onParent parent: ElementHost<R>?,
               reconciler: TreeReconciler<R>) {
        super.prepareForMount()
        
//        self.transaction = transaction
        
        // get target from renderer and store it.
        if let target = reconciler
            .renderer
            .makeTarget(for: self,
                        beforeSibling: sibling,
                        withParent: parentTarget) {
            self.target = target
        }
        // if content is a content container,
        // set target to parent target.
        else if wrappedContent is _SContentContainer {
            self.target = parentTarget
        }
        // a target was not provided by the renderer
        // and it is not a content container, skip it.
        else {
            return
        }
        
        // create and mount children if any exist.
        guard !content.children.isEmpty else { return }
        
        let isGroup = content.type is GroupedContent.Type
        
        children = content.children.map {
            $0.makeElementHost(with: reconciler.renderer,
                               parentTarget: target,
                               parentHost: self)
        }
        
        children.forEach { child in
            child.mount(beforeSibling: isGroup ? sibling : nil,
                        onParent: self,
                        reconciler: reconciler)
        }
        
        super.mount(beforeSibling: sibling,
                    onParent: parent,
                    reconciler: reconciler)
    }
    
    override
    func update(inReconciler reconciler: TreeReconciler<R>) {
        guard let target = target else { return }
        
        invalidateUnmount()
        
        updateEnvironment()
        target.content = content
        reconciler.renderer.update(target,
                                   with: self)
        
        var childrenContent = content.children
        
        // perform updates for children
        switch (children.isEmpty, childrenContent.isEmpty) {
                
                // there are existing children but now no children.
                // unmount all existing children.
            case (false, true):
                children.forEach { host in
                    host.unmount(in: reconciler,
                                 parentTask: parentUnmountTask)
                }
                children = []
                
                // there was no existing children but there are now children.
                // Create hosts for the children and mount them.
            case (true, false):
                children = childrenContent.map { childContent in
                    childContent.makeElementHost(with: reconciler.renderer,
                                                 parentTarget: target,
                                                 parentHost: self)
                }
                children.forEach { childHost in
                    childHost.mount(beforeSibling: nil,
                                    onParent: self,
                                    reconciler: reconciler)
                }
                
                // there are existing and new children.
                // reconcile the differences.
            case (false, false):
                var newChildren = [ElementHost<R>]()
                
                // compare each existing and new child.
                // remount if types differ,
                // otherwise update.
                while let childHost = children.first,
                      let childContent = childrenContent.first {
                    
                    let newChild: ElementHost<R>
                    
                    // same types
                    if childHost.content.typeConstructorName == childContent.typeConstructorName {
//                        childHost.environmentValues = environmentValues
                        childHost.content = childContent
                        childHost.updateEnvironment()
                        childHost.update(inReconciler: reconciler)
                        newChild = childHost
                    }
                    // differing types
                    // create a new element host,
                    // mount the new child,
                    // then unmount the old child.
                    else {
                        newChild = childContent.makeElementHost(with: reconciler.renderer,
                                                                parentTarget: target,
                                                                parentHost: self)
                        newChild.mount(beforeSibling: childHost.findFirstDescendantPrimitiveTarget(),
                                       onParent: self,
                                       reconciler: reconciler)
                        childHost.unmount(in: reconciler,
                                          parentTask: parentUnmountTask)
                    }
                    
                    newChildren.append(newChild)
                    children.removeFirst()
                    childrenContent.removeFirst()
                }
                
                if !children.isEmpty {
                    // more existing host children than new children, unmount them
                    children.forEach { childHost in
                        childHost.unmount(in: reconciler,
                                          parentTask: parentUnmountTask)
                    }
                }
                else {
                    // mount any remaining new children.
                    childrenContent.forEach { childContent in
                        let newChild: ElementHost<R> = childContent.makeElementHost(with: reconciler.renderer,
                                                                                 parentTarget: target,
                                                                                 parentHost: self)
                        newChild.mount(beforeSibling: nil,
                                       onParent: self,
                                       reconciler: reconciler)
                        newChildren.append(newChild)
                    }
                }
                
                children = newChildren
                
            case (true, true):
                // no children to update.
                break
        }
    }
    
    override
    func unmount(in reconciler: TreeReconciler<R>,
                 parentTask: UnmountTask<R>?) {
        super.unmount(in: reconciler,
                      parentTask: parentTask)
        
        guard let target = target else { return }
        
        let task = UnmountHostTask<R>(self,
                                   in: reconciler) {
            self.children.forEach { childHost in
                childHost.unmount(in: reconciler,
                                  parentTask: self.unmountTask)
            }
        }
        
        task.isCancelled = parentTask?.isCancelled ?? false
        unmountTask = task
        parentTask?.childTasks.append(task)
        reconciler.renderer.remove(target,
                                    fromParent: parentTarget,
                                    withTask: task)
    }
    
    /// Stop any unfinished unmounts and complete them without transitions.
    private
    func invalidateUnmount() {
        parentUnmountTask.cancel()
        parentUnmountTask.completeImmediately()
        parentUnmountTask = .init()
    }
}
