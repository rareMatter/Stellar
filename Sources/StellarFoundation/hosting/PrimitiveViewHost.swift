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
// FIXME: Temp public.
public
final
class PrimitiveViewHost: ElementHost {
    
    /// The parent platform content of the `PlatformContent` owned by this host.
    ///
    /// The `PlatformContent` tree does not have a one-to-one relationship with the host tree. Some hosts, such as composites, do not own a `PlatformContent` instance. Therefore, this property is passed down the host tree during mounting.
    private
    let parentPlatformContent: PlatformContent
    
    /// Platform content of this host, supplied by the platform after mounting.
    var platformContent: PlatformContent?
    
    /// If this instance is hosting modified content, this property will contain the instance of content that is modified. This is handed to the platform for rendering along with the applied modifiers.
    private
    var modifiedContent: AnySContent? = nil
    
    private
    var isModifiedContent: Bool { modifiedContent != nil }
    
    private
    var parentUnmountTask = UnmountTask()
    
    init(content: AnySContent,
         parentPlatformContent: PlatformContent,
         parent: ElementHost?) {
        self.parentPlatformContent = parentPlatformContent
        
        super.init(hostedElement: .content(content),
                   parent: parent)
    }
    
    // TODO: Need transaction and reconciler params.
    override
    func mount(beforeSibling sibling: PlatformContent?,
               onParent parent: ElementHost?,
               reconciler: TreeReconciler) {
        super.prepareForMount()
        
        //        self.transaction = transaction
        processModifiedContent()
        
        if let modifiedContent = modifiedContent {
            // modified content is not rendered
            self.platformContent = parentPlatformContent
            
            guard let platformContent = platformContent else {
                fatalError("Platform content was not provided for a primitive host: \(self). Content: \(anyContent.content)")
            }
            
            // modified content has already been unraveled using its children, so the resulting content is the child.
            children = [modifiedContent].map {
                $0.makeHost(parentPlatformContent: platformContent,
                            parentHost: self)
            }
            children.forEach { child in
                child.mount(beforeSibling: nil, onParent: self, reconciler: reconciler)
            }
        }
        else {
            if anyContent.content is GroupedContent {
                // don't give GroupedContent types to the platform renderer
                self.platformContent = parentPlatformContent
            }
            else {
                // create platform content for this host using either the parent platform content or the provider
                self.platformContent = parentPlatformContent
                    .addChild(for: .init(value: anyContent.content), preceedingSibling: sibling, modifiers: modifiers.elements, context: .init())
            }
            
            // abort if no platform content was provided by the platform for this host
            guard let platformContent = platformContent else {
                fatalError("Platform content was not provided for a primitive host: \(self). Content: \(anyContent)")
            }
            
            // create and mount children if the content provides any
            guard !anyContent.children.isEmpty else { return }
            let isGroup = anyContent.content is GroupedContent
            
            children = anyContent.children.map {
                $0.makeHost(parentPlatformContent: platformContent,
                            parentHost: self)
            }
            children.forEach { child in
                child.mount(beforeSibling: isGroup ? sibling : nil,
                            onParent: self,
                            reconciler: reconciler)
            }
        }
        
        super.mount(beforeSibling: sibling,
                    onParent: parent,
                    reconciler: reconciler)
    }
    
    override
    func update(inReconciler reconciler: TreeReconciler) {
        guard let platformContent = platformContent else { return }
        
        invalidateUnmount()
        updateEnvironment()
        processModifiedContent()
        
        platformContent.update(withPrimitive: .init(value: modifiedContent ?? anyContent.content), modifiers: modifiers.elements)
        
        var contentChildren = modifiedContent != nil ? [modifiedContent!] : anyContent.children
        
        // perform updates for children
        switch (children.isEmpty, contentChildren.isEmpty) {
                
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
                children = contentChildren.map { childContent in
                    childContent.makeHost(parentPlatformContent: platformContent,
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
                      let childContent = contentChildren.first {
                    
                    let newChild: ElementHost
                    
                    // same types
                    if childHost.hostedElement.typeConstructorName == childContent.typeConstructorName {
//                        childHost.environmentValues = environmentValues
                        childHost.hostedElement = .content(childContent)
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
                            .makeHost(parentPlatformContent: platformContent,
                                             parentHost: self)
                        newChild.mount(beforeSibling: childHost.firstPrimitivePlatformContent(),
                                       onParent: self,
                                       reconciler: reconciler)
                        childHost.unmount(in: reconciler,
                                          parentTask: parentUnmountTask)
                    }
                    
                    newChildren.append(newChild)
                    children.removeFirst()
                    contentChildren.removeFirst()
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
                    contentChildren.forEach { childContent in
                        let newChild: ElementHost = childContent.makeHost(parentPlatformContent: platformContent,
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
    }
    
    /// Stop any unfinished unmounts and complete them without transitions.
    private
    func invalidateUnmount() {
        parentUnmountTask.cancel()
        parentUnmountTask.completeImmediately()
        parentUnmountTask = .init()
    }
    
    /// Checks if the hosted content is modified content, unwraps the modified content chain and stores the modifiers in self, replacing any inherited modifiers.
    private
    func processModifiedContent() {
        if anyContent.content is SomeModifiedContent {
            guard anyContent.content is AnySModifiedContent else { fatalError() }
            let result = Self.reduceModifiedContent(anyContent)
            modifiedContent = result.modifiedContent
            
            modifiers = inheritedModifiers
            modifiers.replaceAndAppend(contentsOf: result.modifiers.map { Modifier.content($0) })
        }
        else {
            modifiedContent = nil
            modifiers = []
        }
    }
}
