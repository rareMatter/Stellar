//
//  PrimitiveSceneHost.swift
//  
//
//  Created by Jesse Spencer on 11/7/22.
//

import Foundation

final
class PrimitiveSceneHost: ElementHost {
    
    var anyScene: AnySScene {
        get {
            guard case let .scene(scene) = hostedElement else {
                fatalError()
            }
            return scene
        }
        set { hostedElement = .scene(newValue) }
    }
    
    /// The parent platform content of the `PlatformContent` owned by this host.
    ///
    /// The `PlatformContent` tree does not have a one-to-one relationship with the host tree. Some hosts, such as composites, do not own a `PlatformContent` instance. Therefore, this property is passed down the host tree during mounting.
    private
    let parentPlatformContent: PlatformContent
    
    /// Platform content of this host, supplied by the platform after mounting.
    var platformContent: PlatformContent?
    
    /// If this instance is hosting modified content, this property will contain the instance of content that is modified. This is handed to the platform for rendering along with the applied modifiers.
    private
    var modifiedContent: AnySScene? = nil
    
    private
    var isModifiedContent: Bool { modifiedContent != nil }
    
    private
    var parentUnmountTask = UnmountTask()
    
    init(scene: AnySScene,
         parentPlatformContent: PlatformContent,
         parent: ElementHost?) {
        self.parentPlatformContent = parentPlatformContent
        super.init(hostedElement: .scene(scene), parent: parent)
    }
    
    override func mount(beforeSibling sibling: PlatformContent?, onParent parent: ElementHost?, reconciler: TreeReconciler) {
        super.prepareForMount()
        
        processModifiedContent()
        
        if let modifiedContent = modifiedContent {
            // modified content is not rendered
            self.platformContent = parentPlatformContent
            
            guard let platformContent = platformContent else {
                fatalError("Platform content was not provided for a primitive host: \(self). Scene: \(anyScene.wrappedScene)")
            }
            
            // modified content has already been unraveled using its children, so the resulting content is the child.
            children = [modifiedContent].map {
                $0.makeHost(parentPlatformContent: platformContent, parentHost: self)
            }
            children.forEach { childHost in
                childHost.mount(beforeSibling: nil, onParent: self, reconciler: reconciler)
            }
        }
        else {
            if anyScene is GroupedContent {
                self.platformContent = parentPlatformContent
            }
            else {
                self.platformContent = parentPlatformContent
                    .addChild(for: .init(value: anyScene), preceedingSibling: sibling, modifiers: modifiers.elements, context: .init())
            }
            
            guard let platformContent = platformContent else {
                fatalError("Platform content was not provided for a primitive host: \(self). Scene: \(anyScene)")
            }
            
            guard !anyScene.children.isEmpty else { return }
            let isGroup = anyScene is GroupScene
            
            children = anyScene.children.map {
                $0.makeHost(parentPlatformContent: platformContent, parentHost: self)
            }
            children.forEach { child in
                child.mount(beforeSibling: isGroup ? sibling : nil, onParent: self, reconciler: reconciler)
            }
        }
        
        super.mount(beforeSibling: sibling, onParent: parent, reconciler: reconciler)
    }
    
    override func update(inReconciler reconciler: TreeReconciler) {
        guard let platformContent = platformContent else {
            return
        }
        
        invalidateUnmount()
        updateEnvironment()
        processModifiedContent()
        
        platformContent.update(withPrimitive: .init(value: modifiedContent ?? anyScene.wrappedScene), modifiers: modifiers.elements)
        
        var sceneChildren = modifiedContent != nil ?
        [modifiedContent!] : anyScene.children
        
        // perform updates for children
        switch (children.isEmpty, sceneChildren.isEmpty) {
            
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
            children = sceneChildren.map { childContent in
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
                  let childScene = sceneChildren.first {
                
                let newChild: ElementHost
                
                // same types
                if childHost.hostedElement.typeConstructorName == childScene.typeConstructorName {
                    //                        childHost.environmentValues = environmentValues
                    childHost.hostedElement = .scene(childScene)
                    childHost.updateEnvironment()
                    childHost.update(inReconciler: reconciler)
                    newChild = childHost
                }
                // differing types
                // create a new element host,
                // mount the new child,
                // then unmount the old child.
                else {
                    newChild = childScene
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
                sceneChildren.removeFirst()
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
                sceneChildren.forEach { childScene in
                    let newChild: ElementHost = childScene.makeHost(parentPlatformContent: platformContent,
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
    
    override func unmount(in reconciler: TreeReconciler, parentTask: UnmountTask?) {
        super.unmount(in: reconciler, parentTask: parentTask)
        
        guard let platformContent = platformContent else { return }
        
        let task = UnmountHostTask(self,
                                   in: reconciler) {
            self.children.forEach { childHost in
                childHost.unmount(in: reconciler, parentTask: self.unmountTask)
            }
        }
        
        task.isCancelled = parentTask?.isCancelled ?? false
        unmountTask = task
        parentTask?.childTasks.append(task)
        parentPlatformContent.removeChild(platformContent, for: task)
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
        if anyScene.wrappedScene is SomeModifiedContent {
            guard anyScene.wrappedScene is AnySModifiedContent else { fatalError() }
            let result = Self.reduceModifiedScene(anyScene)
            modifiedContent = result.modifiedScene
            
            modifiers = inheritedModifiers
            modifiers.replaceAndAppend(contentsOf: result.modifiers.map { Modifier.scene($0) })
        }
        else {
            modifiedContent = nil
            modifiers = []
        }
    }
}
