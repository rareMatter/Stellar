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
class PrimitiveViewHost: ElementHost {
    
    /// Target of the closest ancestor host view or nil if this is a root.
    ///
    /// A parent of this view might be a composite, therefore it must be passed to the first descendant host views.
    ///
    /// This means the `parentTarget` is not always the same as the target of a parent `View`.
    private
    let parentTarget: PlatformContent?
    
    /// Renderable target of this host, supplied by the platform after mounting.
    ///
    /// This is provided from either the parent platform content or a closure if this is the root host.
    private(set)
    var target: PlatformContent?
    
    /// The platform content provider when this host is the root (and the content cannot be retrieved from the parent platform content).
    private
    let targetProvider: ((AnySContent) -> PlatformContent)?
    
    private
    var parentUnmountTask = UnmountTask()
    
    init(content: AnySContent,
         parentTarget: PlatformContent?,
         parent: ElementHost?) {
        self.parentTarget = parentTarget
        self.targetProvider = nil
        
        super.init(hostedElement: .content(content),
                   parent: parent)
    }
    
    init<C>(content: C,
            platformContentProvider: @escaping (C) -> PlatformContent,
            parent: ElementHost?)
    where C : SContent {
        self.targetProvider = { anyContent in
            guard let content = anyContent.content as? C else { fatalError("Unexpected type.") }
            return platformContentProvider(content)
        }
        self.parentTarget = nil
        
        super.init(content: AnySContent(content),
                   parent: parent)
    }
    
    // TODO: Need transaction and reconciler params.
    override
    func mount(beforeSibling sibling: PlatformContent?,
               onParent parent: ElementHost?,
               reconciler: TreeReconciler) {
        super.prepareForMount()
        
//        self.transaction = transaction
        
        // render and store the instance
        if let target = parentTarget?
            .makeChild(using: self,
                       preceeding: sibling) {
            self.target = target
        }
        // if parent is nil, this is a root host.
        else if let targetProvider = self.targetProvider {
            self.target = targetProvider(self.content)
        }
        // if content is a content container,
        // set target to parent target.
        else if wrappedContent is _SContentContainer {
            self.target = parentTarget
        }
        
        guard let target = target else { return }
        // create and mount children if any exist.
        guard !content.children.isEmpty else { return }
        
        let isGroup = content.type is GroupedContent.Type
        
        children = content.children.map {
            $0.makeElementHost(parentTarget: target,
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
    func update(inReconciler reconciler: TreeReconciler) {
        guard let target = target else { return }
        
        invalidateUnmount()
        
        updateEnvironment()

        target.update(withHost: self)
        
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
                    childContent.makeElementHost(parentTarget: target,
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
                var newChildren = [ElementHost]()
                
                // compare each existing and new child.
                // remount if types differ,
                // otherwise update.
                while let childHost = children.first,
                      let childContent = childrenContent.first {
                    
                    let newChild: ElementHost
                    
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
                        newChild = childContent
                            .makeElementHost(parentTarget: target,
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
                        let newChild: ElementHost = childContent.makeElementHost(parentTarget: target,
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
    func unmount(in reconciler: TreeReconciler,
                 parentTask: UnmountTask?) {
        super.unmount(in: reconciler,
                      parentTask: parentTask)
        
        guard let parentTarget = parentTarget else {
            assertionFailure("Attempt to remove the root host's target. This would leave an empty hierarchy.")
            return
        }
        guard let target = target else { return }
        
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
        parentTarget.removeChild(target,
                                  forTask: task)
    }
    
    /// Stop any unfinished unmounts and complete them without transitions.
    private
    func invalidateUnmount() {
        parentUnmountTask.cancel()
        parentUnmountTask.completeImmediately()
        parentUnmountTask = .init()
    }
}
